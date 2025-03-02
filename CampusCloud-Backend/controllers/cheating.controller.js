import CheatingRecord from "../models/cheating.models.js";
import Student from "../models/student.models.js";
// import Faculty from "../models/facility.models.js";

// @desc    Create a cheating record
// @route   POST /api/cheating
// @access  Private (Faculty only)
export const createCheatingRecord = async (req, res) => {
  try {
    const { studentId, title, description, proof } = req.body;
    console.log(studentId, title, description, proof)
    let arr = [];
    arr.push(proof)

    const student = await Student.findById(studentId);
    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    const cheatingRecord = new CheatingRecord({
      student: studentId,
      title,
      description,
      proof: arr,
      caughtBy: req.faculty?._id, 
    });

    await cheatingRecord.save();
    res.status(200).json({ message: "Cheating record created successfully", record: cheatingRecord });
  } catch (error) {
    console.log(error)
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all cheating records
// @route   GET /api/cheating
export const getCheatingRecords = async (req, res) => {
  try {
    const records = await CheatingRecord.find().populate("student", "name email");
    // console.log(records)
    res.status(200).json(records);
  } catch (error) {
    console.log(error)
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get a single cheating record by ID
// @route   GET /api/cheating/:id
// @access  Private (Admin & Faculty only)
export const updateCheatingRecord = async (req, res) => {
    try {
      const { studentId, title, description, proof } = req.body;
  
      // Find the record by ID and update it
      const updatedRecord = await CheatingRecord.findByIdAndUpdate(
        req.params.id, // Find the record by ID
        { studentId, title, description, proof, caughtBy:req.faculty._id }, // Only update provided fields
        { new: true } // Return the updated document
      );
  
      if (!updatedRecord) {
        return res.status(404).json({ message: "Cheating record not found" });
      }
  
      res.status(200).json(updatedRecord);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  
// @desc    Delete a cheating record
// @route   DELETE /api/cheating/:id
// @access  Private (Faculty only)
export const deleteCheatingRecord = async (req, res) => {
  try {
    const record = await CheatingRecord.findById(req.params.id);
    if (!record) {
      return res.status(404).json({ message: "Cheating record not found" });
    }

    if (record.caughtBy.toString() !== req.student._id.toString()) {
      return res.status(403).json({ message: "Not authorized to delete this record" });
    }

    await record.deleteOne();
    res.status(200).json({ message: "Cheating record deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
