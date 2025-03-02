import express from "express";
import { createRequest, getAllRequests, getRequestById, deleteRequest } from "../controllers/request.controller.js";
import { studentAuthMiddleware } from "../middlewares/auth.js";

const router = express.Router();

// Create a new request
router.post("/", studentAuthMiddleware, createRequest);

// Get all requests
router.get("/", getAllRequests);

// Get a request by ID
router.get("/:id", getRequestById);

// Delete a request
router.delete("/:id", deleteRequest);

export default router;
