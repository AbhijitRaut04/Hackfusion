import express from "express";
import {
  createComplaint,
  getAllComplaints,
//   getComplaintById,
  deleteComplaint,
  increaseAnonymousCount,
} from "../controllers/complaint.controller.js";
import { studentAuthMiddleware, isFacultyAuthority } from "../middlewares/auth.js";

const router = express.Router();

// Create a new complaint (only for authenticated students)
router.post("/", studentAuthMiddleware, createComplaint);

// Get all complaints (for admin or faculty handling complaints)
router.get("/", studentAuthMiddleware, getAllComplaints);

router.patch("/approve/:complaintId", isFacultyAuthority, increaseAnonymousCount)

// Get a single complaint by ID
// router.get("/:id", studentAuthMiddleware, getComplaintById);

// Delete a complaint (only student who created it can delete)
// router.delete("/:id", studentAuthMiddleware, deleteComplaint);

export default router;
