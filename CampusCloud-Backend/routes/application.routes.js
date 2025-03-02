import express from "express";
import { getAllApplications, getStudentApplications, getApplicationsForFaculty, createApplication, approveApplication, rejectApplication, generateApplication, getApplicationPrint } from "../controllers/application.controller.js";
import { facultyAuthMiddleware, isFacultyAuthority, studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

router.use(express.static("public"));


router.post("/", studentAuthMiddleware, createApplication);
router.get("/all", facultyAuthMiddleware, getAllApplications);
router.get("/my-applications", studentAuthMiddleware, getStudentApplications);
router.get("/faculty-applications", isFacultyAuthority, getApplicationsForFaculty);
router.patch("/approve/:applicationId", isFacultyAuthority, approveApplication);
router.patch("/reject/:applicationId", isFacultyAuthority, rejectApplication);
router.get("/priint/:applicationId", studentAuthMiddleware, generateApplication);
router.get("/generate-html/:applicationId", getApplicationPrint);


export default router;
