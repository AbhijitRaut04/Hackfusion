import express from "express";
import {
  createCheatingRecord,
  getCheatingRecords,
//   getCheatingRecordById,
  deleteCheatingRecord,
  updateCheatingRecord,
} from "../controllers/cheating.controller.js";
import { facultyAuthMiddleware, studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// Create a new cheating record (Only faculty can create)
router.post("/", createCheatingRecord);

// Get all cheating records (Admin & Faculty can view)
router.get("/", getCheatingRecords);

router.put("/:id", facultyAuthMiddleware, updateCheatingRecord);

// Delete a cheating record (Only faculty can delete)
router.delete("/:id", facultyAuthMiddleware, deleteCheatingRecord);

export default router;
