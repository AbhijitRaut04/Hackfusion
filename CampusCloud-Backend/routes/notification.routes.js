import express from "express";
import {
  createNotification,
  getNotificationsForStudent,
  deleteNotification,
} from "../controllers/notification.controller.js";
import { facultyAuthMiddleware, isFacultyAuthority, studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// Create a notification (Only Admin/Faculty can create)
router.post("/", isFacultyAuthority, createNotification);

// Get notifications for a student (Authenticated student can access)
router.get("/", studentAuthMiddleware, getNotificationsForStudent);

// Delete a notification (Only Admin can delete)
router.delete("/:id", facultyAuthMiddleware, deleteNotification);

export default router;
