import express from "express";
import {
  bookSlot,
  getBookedSlots,
  getBookingById,
  updateBookingStatus,
  deleteBooking,
} from "../controllers/facilitybooking.controller.js";
import { studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// Create a new booking
router.post("/book", studentAuthMiddleware,bookSlot);

// Get all bookings
router.post("/", getBookedSlots);

// Get a booking by ID
// router.get("/:id", getBookingById);

// Update booking status (approve/reject)
// router.put("/:id", updateBookingStatus);

// Delete a booking
// router.delete("/:id", deleteBooking);

export default router;
