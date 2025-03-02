import { generateLetterHTML } from "../config/letterTemplate.js";
import Application from "../models/application.models.js";
import FacultyAuthority from "../models/facultyauthorities.models.js";
import Student from "../models/student.models.js";
import StudentAuthority from "../models/studentauthorities.models.js";
import Notification from "../models/notification.models.js";

// Create a new application
export const createApplication = async (req, res) => {
  try {
    const { title, to, body, file, receipantAuthorityType, priority } = req.body;
    const from = req.student._id;

    if (!title || !to || !body) {
      return res.status(400).json({ message: "Title, to and body are required" });
    }
    let toData = [];

    for (let id of to) {
      toData.push({ authority: id, status: "pending" })
    }

    const newApplication = new Application({
      from,
      title,
      to: toData,
      body,
      file: file ?? "",
      priority: priority ?? "high"
    });
    await newApplication.save();

    // Create notifications for each recipient
    const notifications = to.map((authorityEmail) => ({
      title: "New Application Received",
      description: `You have received a new application: "${title}".`,
      notifiedTo: authorityEmail, // Authority who will receive the notification (Storing Email)
      from: from, // Student who applied
      fromModel: receipantAuthorityType ?? "FacultyAuthority", // Assuming it's sent to faculty if not mentioned
    }));

    await Notification.insertMany(notifications);

    res.status(200).json({ message: "Application created successfully", application: newApplication });

  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

// Get all applications (visible to all students)
export const getAllApplications = async (req, res) => {
  try {
    let applications = await Application.find();

    // Fetch 'from' and 'to' details manually
    applications = await Promise.all(
      applications.map(async (app) => {
        // Fetch `from` details
        const fromEntity = await Student.findOne({ _id: app.from }).select("name email");

        // Fetch `to` details
        const toEntities = await Promise.all(
          app.to.map(async (toId) => {
            const faculty = await FacultyAuthority.findOne({ _id: toId.authority }).select("name email");
            if (faculty) return { to: faculty.toObject(), status: toId.status };

            const studentAuth = await StudentAuthority.findOne({ _id: toId.authority }).select("name email");
            return studentAuth ? { to: studentAuth.toObject(), status: toId.status } : null;
          })
        );

        return {
          ...app.toObject(),
          from: fromEntity ? fromEntity.toObject() : null,
          to: toEntities.filter(Boolean),
        };
      })
    );

    res.status(200).json({ applications });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getStudentApplications = async (req, res) => {
  try {
    let applications = await Application.find({ from: req.student._id }).lean();

    // Fetch 'from' and 'to' details manually
    applications = await Promise.all(
      applications.map(async (app) => {
        const student = await Student.findById(app.from).select("name email").lean();

        const toEntities = await Promise.all(
          app.to.map(async (entry) => {
            const email = entry.authority; 
            
            const facultyAuthority = await FacultyAuthority.findOne({ email }).populate("faculty").lean();
            if (facultyAuthority && facultyAuthority.faculty) {
              return {
                authority: entry.authority,
                status: entry.status,
                _id: entry._id, 
                name: facultyAuthority.faculty.name || "Unknown",
                registrationNo: facultyAuthority.faculty.registrationNo || "N/A", 
                role: "Faculty Authority"
              };
            }

            const studentAuthority = await StudentAuthority.findOne({ email }).populate("student").lean();
            if (studentAuthority && studentAuthority.student) {
              return {
                authority: entry.authority,
                status: entry.status,
                _id: entry._id, 
                name: studentAuthority.student.name || "Unknown", 
                registrationNo: studentAuthority.student.registrationNo || "N/A", 
                role: "Student Authority"
              };
            }
            // Return the original object if no match is found
            return {
              authority: entry.authority,
              status: entry.status,
              _id: entry._id
            };
          })
        );
        return {
          ...app, 
          from: student ? student : null,
          to: toEntities,
        };
      })
    );

    res.status(200).json(applications);
  } catch (error) {
    res.status(500).json({ error: "Server error", details: error.message });
  }
};



// Get applications addressed to a faculty or faculty authority
export const getApplicationsForFaculty = async (req, res) => {
  try {
    let applications = await Application.find({ "to.authority": req.authorityFaculty._id });

    applications = await Promise.all(
      applications.map(async (app) => {
        // Fetch `from` details
        const fromEntity = await Student.findOne({ _id: app.from }).select("name email");

        // Fetch `to` details
        const toEntities = await Promise.all(
          app.to.map(async (toId) => {
            const faculty = await FacultyAuthority.findOne({ _id: toId.authority }).populate("faculty");
            if (faculty) return { authority: faculty.toObject(), status: toId.status };

            const studentAuth = await StudentAuthority.findOne({ _id: toId.authority }).populate("student");
            return studentAuth ? { authority: studentAuth.toObject(), status: toId.status } : null;
          })
        );

        return {
          ...app.toObject(),
          from: fromEntity ? fromEntity.toObject() : null, // Convert `from` to object
          to: toEntities.filter(Boolean), // Remove null values
        };
      })
    );

    res.status(200).json({ applications });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const approveApplication = async (req, res) => {
  try {
    let application = await Application.findById(req.params.applicationId);

    if (!application) {
      return res.status(404).json({ message: "Application not found" });
    }

    let facultyId = req.authorityFaculty._id;
    let updated = false;

    // Update the status
    application.to.forEach((toObj) => {
      if (toObj.authority.toString() === facultyId.toString()) {
        toObj.status = "approved";
        updated = true;
      }
    });

    if (!updated) {
      return res.status(403).json({ message: "Unauthorized: You cannot approve this application" });
    }

    // Save the changes to the database
    await application.save();

    res.status(200).json({ message: "Application approved successfully", application });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const rejectApplication = async (req, res) => {
  try {
    let application = await Application.findById(req.params.applicationId);

    if (!application) {
      return res.status(404).json({ message: "Application not found" });
    }

    let facultyId = req.authorityFaculty._id;
    let updated = false;

    application.to.forEach((toObj) => {
      if (toObj.authority.toString() === facultyId.toString()) {
        toObj.status = "rejected";
        updated = true;
      }
    });

    if (!updated) {
      return res.status(403).json({ message: "Unauthorized: You cannot reject this application" });
    }

    await application.save();

    res.status(200).json({ message: "Application rejected successfully", application });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const generateApplication = async (req, res) => {
  try {
    let application = await Application.findById(req.params.applicationId);

    if (!application) {
      return res.status(404).json({ message: "Application not found" });
    }

    let facultyId = req.authorityFaculty._id;
    let updated = false;

    application.to.forEach((toObj) => {
      if (toObj.authority.toString() === facultyId.toString()) {
        toObj.status = "rejected";
        updated = true;
      }
    });

    if (!updated) {
      return res.status(403).json({ message: "Unauthorized: You cannot reject this application" });
    }

    await application.save();

    res.status(200).json({ message: "Application rejected successfully", application });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}


export const getApplicationPrint = async (req, res) => {
  try {
      const app = await Application.findById(req.params.applicationId);
      if (!app) {
          return res.status(404).send("Application not found");
      }

      if (app.to.some(receipent => receipent.status !== "approved")) {
        return res.status(403).send({ message: "Applications not approved yet" });
      }
      

      // Fetch `from` details
      const fromEntity = await Student.findById(app.from).select("name email");

      // Fetch `to` details
      const toEntities = await Promise.all(
          app.to.map(async (toId) => {
              const faculty = await FacultyAuthority.findById(toId.authority).populate("faculty");
              if (faculty) return faculty.toObject();
              const studentAuth = await StudentAuthority.findById(toId.authority).populate("student");
              return studentAuth ? studentAuth.toObject() : null;
          })
      );

      const applicationData = {
          ...app.toObject(),
          from: fromEntity ? fromEntity.toObject() : null,
          to: toEntities.filter(Boolean), 
      };

      // Generate HTML content
      const htmlContent = generateLetterHTML(applicationData);
      res.send(htmlContent);
  } catch (error) {
      console.error("Printing application:", error);
      res.status(500).send("Internal Server Error");
  }
}