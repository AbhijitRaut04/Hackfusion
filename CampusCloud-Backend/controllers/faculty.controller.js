import Faculty from "../models/faculty.models.js";
import bcryptjs from 'bcryptjs'
import jwt from 'jsonwebtoken'

// @desc    Create a new faculty
// @route   POST /api/faculties
// @access  Public (can be restricted as needed)
export const createFaculty = async (req, res) => {
  try {
    const { registrationNo, name, email, password, department, phone } = req.body;

    if (!password || typeof password !== "string") {
      return res.status(400).json({ message: "Invalid or missing password" });
    }

    // Check if faculty with email or registrationNo already exists
    const existingFaculty = await Faculty.findOne({ 
      $or: [{ email }, { registrationNo }] 
    });

    if (existingFaculty) {
      return res.status(400).json({ message: "Faculty with this email or registration number already exists" });
    }

    const hashedPassword = await bcryptjs.hash(password, 10);

    // Create new faculty
    const faculty = new Faculty({
      registrationNo,
      name,
      email,
      password: hashedPassword,
      department,
      phone,
    });

    await faculty.save();
    res.status(200).json({ message: "Faculty created successfully", faculty });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.log(error);
  }
};


export const loginFaculty = async (req, res) => {
  try {

    const { email, password } = req.body;

    const faculty = await Faculty.findOne({ email });

    if (!faculty) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }


    const isMatch = await bcryptjs.compare(password, faculty.password);

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    const payload = { facultyId: faculty.id, username: faculty.username };

    const token = jwt.sign(payload, process.env.JWT_SECRET_KEY);

    res.cookie("token", token)
    res.cookie("role", "faculty")

    res.status(200).send({ token, role: "faculty" });

  } catch (error) {
    res.status(500).send({ message: error.message })
  }
};


// @desc    Get all faculties
// @route   GET /api/faculties
// @access  Public (can be restricted)
export const getAllFaculties = async (req, res) => {
  try {
    const faculties = await Faculty.find();
    res.status(200).json(faculties);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get faculty by ID
// @route   GET /api/faculties/:id
// @access  Public (can be restricted)
export const getFacultyById = async (req, res) => {
  try {
    const faculty = await Faculty.findById(req.params.id);

    if (!faculty) {
      return res.status(404).json({ message: "Faculty not found" });
    }

    res.status(200).json(faculty);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update faculty details
// @route   PUT /api/faculties/:id
// @access  Private (should require authentication)
export const updateFaculty = async (req, res) => {
  try {
    const faculty = await Faculty.findById(req.params.id);

    if (!faculty) {
      return res.status(404).json({ message: "Faculty not found" });
    }

    // Update fields
    Object.assign(faculty, req.body);
    await faculty.save();

    res.status(200).json({ message: "Faculty updated successfully", faculty });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete a faculty
// @route   DELETE /api/faculties/:id
// @access  Private (should require authentication)
export const deleteFaculty = async (req, res) => {
  try {
    const faculty = await Faculty.findByIdAndDelete(req.params.id);

    if (!faculty) {
      return res.status(404).json({ message: "Faculty not found" });
    }

    res.status(200).json({ message: "Faculty deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
