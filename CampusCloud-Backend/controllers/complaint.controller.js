import Complaint from "../models/complaint.models.js";

// @desc    Create a new complaint
// @route   POST /api/complaints
// @access  Private (only students)
export const createComplaint = async (req, res) => {
    try {
        const { title, complaintTo, description, attachments } = req.body;
        const studentId = req.student._id; // Extract student from request

        const complaint = new Complaint({
            title,
            complaintTo,
            description,
            student: studentId,
            keepAnonymousCount: 0,
            attachments,
        });

        await complaint.save();
        res.status(200).json({ message: "Complaint submitted successfully", complaint });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Get all complaints
// @route   GET /api/complaints
// @access  Private (Admin/Faculty)
export const getAllComplaints = async (req, res) => {
    try {
        let complaints = await Complaint.find()
            .populate("student", "name email")
            .sort({ createdAt: -1 });

        complaints = complaints.map((complaint) => {
            if (complaint.keepAnonymousCount <= process.env.COUNT_OF_BOARD_OF_AUTHORITIES / 2) {
                complaint.student = null;
            }
            return complaint;
        })

        res.status(200).json(complaints);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const increaseAnonymousCount = async (req, res) => {
    try {
        let complaint = await Complaint.findById(req.params.complaintId);
        complaint.keepAnonymousCount = complaint.keepAnonymousCount + 1;
        await complaint.save();
        return res.status(200).send({ message: "Data updated successfully" })
    } catch (error) {
        res.status(500).send({ message: error.message })
    }
}

export const decreaseAnonymousCount = async (req, res) => {
    try {
        let complaint = await Complaint.findById(req.params.complaintId);
        complaint.keepAnonymousCount = complaint.keepAnonymousCount - 1;
        await complaint.save();
        return res.status(200).send({ message: "Data updated successfully" })
    } catch (error) {
        res.status(500).send({ message: error.message })
    }
}

// @desc    Get a complaint by ID
// @route   GET /api/complaints/:id
// @access  Private (Student who filed it or Admin)
export const getComplaintById = async (req, res) => {
    try {
        const complaint = await Complaint.findById(req.params.id).populate("student", "name email");

        if (!complaint) {
            return res.status(404).json({ message: "Complaint not found" });
        }


        res.status(200).json(complaint);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Update complaint status
// @route   PUT /api/complaints/:id
// @access  Private (Admin/Faculty handling complaints)
export const updateComplaintStatus = async (req, res) => {
    try {
        const { status } = req.body;

        const complaint = await Complaint.findById(req.params.id);

        if (!complaint) {
            return res.status(404).json({ message: "Complaint not found" });
        }

        complaint.status = status;
        await complaint.save();

        res.status(200).json({ message: `Complaint marked as ${status}`, complaint });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Delete a complaint
// @route   DELETE /api/complaints/:id
// @access  Private (Only student who created it)
export const deleteComplaint = async (req, res) => {
    try {
        const complaint = await Complaint.findById(req.params.id);

        if (!complaint) {
            return res.status(404).json({ message: "Complaint not found" });
        }

        // Only the student who created the complaint can delete it
        if (complaint.student.toString() !== req.student._id.toString()) {
            return res.status(403).json({ message: "Not authorized to delete this complaint" });
        }

        await complaint.deleteOne();
        res.status(200).json({ message: "Complaint deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
