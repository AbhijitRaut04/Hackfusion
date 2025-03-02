import { sendEmail } from "../config/sendemail.js";
import HealthLeaveNotification from "../models/healthleave.models.js";
import Student from "../models/student.models.js";

// 📌 Create a new health leave notification
export const createHealthLeave = async (req, res) => {
  try {
    const { studentId, mailTo, startDate, endDate, title } = req.body;

    const newLeave = new HealthLeaveNotification({ student:studentId, mailTo, startDate, endDate, title });
    await newLeave.save();

    const student = await Student.findById(studentId);

    let message = `
        Dear HOD of CSE Dept.,\n

        I hope this email finds you well.\n

        I am writing to inform you that ${student.name} (Reg. No: ${student.registrationNo}) has been advised medical leave due to ${title}. The leave period is from ${startDate} to ${endDate}.\n

        Please consider this official notification regarding the student's absence. If any further documentation is required, kindly let me know.\n

        Thank you for your understanding.\n

        Best regards,\n
        Dispensary In-Charge\n
        SGGSIE&T, Vishnupuri\n
    `

    sendEmail(mailTo, title, message)
    let parentMail = "abhijitmraut8010@gmail.com"
    sendEmail(parentMail, title, message)



    res.status(200).json({ message: "Health Leave Notification created successfully", leave: newLeave });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 📌 Get all health leave notifications
export const getAllHealthLeaves = async (req, res) => {
  try {
    const leaves = await HealthLeaveNotification.find({ student: req.student._id }).populate("student mailTo");
    console.log(leaves)
    res.status(200).json(leaves);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 📌 Get a single health leave notification by ID
// export const getHealthLeaveById = async (req, res) => {
//   try {
//     const leave = await HealthLeaveNotification.findById(req.params.id).populate("student mailTo");
//     if (!leave) return res.status(404).json({ message: "Health Leave Notification not found" });

//     res.status(200).json(leave);
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// };

// // 📌 Update a health leave notification
// export const updateHealthLeave = async (req, res) => {
//   try {
//     const { student, mailTo, startDate, endDate, title } = req.body;
//     const updatedLeave = await HealthLeaveNotification.findByIdAndUpdate(
//       req.params.id,
//       { student, mailTo, startDate, endDate, title },
//       { new: true, runValidators: true }
//     );

//     if (!updatedLeave) return res.status(404).json({ message: "Health Leave Notification not found" });

//     res.status(200).json({ message: "Health Leave Notification updated successfully", leave: updatedLeave });
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// };

// // 📌 Delete a health leave notification
// export const deleteHealthLeave = async (req, res) => {
//   try {
//     const deletedLeave = await HealthLeaveNotification.findByIdAndDelete(req.params.id);
//     if (!deletedLeave) return res.status(404).json({ message: "Health Leave Notification not found" });

//     res.status(200).json({ message: "Health Leave Notification deleted successfully" });
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// };
