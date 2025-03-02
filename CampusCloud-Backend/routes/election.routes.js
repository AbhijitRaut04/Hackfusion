import express from "express";
import {
  createElection,
  getElectionDetails,
  getElectionInfo,
  voteForElection,
  // registerForElection,
  // approveCandidate,
  // rejectCandidate,
} from "../controllers/election.controller.js";
import { isFacultyAuthority, studentAuthMiddleware } from "../middlewares/auth.js";
import { isPasswordCorrect, validateSelfie } from "../middlewares/utilities.js";

const router = express.Router();

// Create an election (Only faculty can create)
router.post("/", isFacultyAuthority, createElection);

router.get("/detail", studentAuthMiddleware, getElectionDetails)

router.post("/vote", studentAuthMiddleware, isPasswordCorrect, validateSelfie, voteForElection);

router.get("/", getElectionInfo)

// Register as a candidate (Only students can register)
// router.post("/:id/register", studentAuthMiddleware, registerForElection);

// Approve a candidate (Only faculty can approve)
// router.put("/:electionId/approve/:candidateId", isFacultyAuthority, approveCandidate);

// router.put("/:electionId/reject/:candidateId", isFacultyAuthority, rejectCandidate);

export default router;
