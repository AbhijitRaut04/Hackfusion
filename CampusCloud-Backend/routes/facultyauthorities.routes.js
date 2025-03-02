import express from "express";
import { createFacultyAuthority, getFacultyAuthorities, loginFacultyAuthority } from "../controllers/facultyauthority.controller.js";

const router = express.Router();

// Route to create a new faculty authority
router.post("/", createFacultyAuthority);

// Route to get all faculty authorities
router.get("/", getFacultyAuthorities);

router.post("/login", loginFacultyAuthority);


export default router;
