import express from "express";
import { bookSlot, getAllAppointments, getAppointmentsByStudent, getBookedSlots } from "../controllers/appointment.controller.js";
import { studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

router.post("/book-slot", studentAuthMiddleware, bookSlot);
router.get("/get-booked-slots", studentAuthMiddleware, getBookedSlots);
router.get("/", getAllAppointments);
router.get("/:studentId", getAppointmentsByStudent)

export default router;
