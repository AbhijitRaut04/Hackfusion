import express from "express";
import {
  createFaculty,
  getAllFaculties,
  getFacultyById,
  updateFaculty,
  deleteFaculty,
  loginFaculty,
} from "../controllers/faculty.controller.js";

const router = express.Router();

// Create a new faculty
router.post("/", createFaculty);

router.post("/login", loginFaculty);

// Get all faculties
router.get("/", getAllFaculties);

// Get a faculty by ID
router.get("/:id", getFacultyById);

// // Update faculty details
// router.put("/:id", updateFaculty);

// // Delete a faculty
// router.delete("/:id", deleteFaculty);

export default router;
