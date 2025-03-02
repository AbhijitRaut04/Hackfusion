import Notification from "../models/notification.models.js";
import Student from "../models/student.models.js";

// @desc    Create a notification
// @route   POST /api/notifications
// @access  Private (Admin/Faculty only)
export const createNotification = async (req, res) => {
  try {
    const { title, description, notifiedTo } = req.body;

    // Check if student exists
    const student = await Student.findById(notifiedTo);
    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    const notification = new Notification({
      title,
      description,
      notifiedTo,
      from:req.faculty?._id
    });

    await notification.save();
    res.status(200).json({ message: "Notification created successfully", notification });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get notifications for a student
// @route   GET /api/notifications
// @access  Private (Authenticated Student)
export const getNotificationsForStudent = async (req, res) => {
  try {
    const notifications = await Notification.find({ notifiedTo: req.student._id }).sort({ createdAt: -1 });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete a notification
// @route   DELETE /api/notifications/:id
// @access  Private (Admin only)
export const deleteNotification = async (req, res) => {
  try {
    const notification = await Notification.findById(req.params.id);
    if (!notification) {
      return res.status(404).json({ message: "Notification not found" });
    }

    await notification.deleteOne();
    res.status(200).json({ message: "Notification deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
