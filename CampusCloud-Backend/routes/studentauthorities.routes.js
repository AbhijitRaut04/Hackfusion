import express from "express";
import { createStudentAuthority, getStudentAuthorities, loginStudentAuthority } from "../controllers/studentauthorities.controller.js";
import { facultyAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// Route to create a new student authority
router.post("/", facultyAuthMiddleware, createStudentAuthority);

// Route to get all student authorities
router.get("/", getStudentAuthorities);

router.post("/login", loginStudentAuthority)

export default router;
