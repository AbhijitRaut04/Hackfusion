import express from "express";
import {
  createHealthLeave,
  getAllHealthLeaves,
//   getHealthLeaveById,
//   updateHealthLeave,
//   deleteHealthLeave,
} from "../controllers/healthleave.controller.js";
import { facultyAuthMiddleware, studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// 📌 Define routes
router.post("/",facultyAuthMiddleware, createHealthLeave);           // Create new health leave
router.get("/", studentAuthMiddleware, getAllHealthLeaves);           // Get all health leaves
// router.get("/:id", getHealthLeaveById);        // Get a specific health leave
// router.put("/:id", updateHealthLeave);         // Update a health leave
// router.delete("/:id", deleteHealthLeave);      // Delete a health leave

export default router;
