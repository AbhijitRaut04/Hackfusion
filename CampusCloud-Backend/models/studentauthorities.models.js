import { request } from "express";
import mongoose from "mongoose";

const StudentAuthoritiesSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true,
    },
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    position: {
      type: String,
      required: true,
      trim: true,
    },
    signature: {
      type: String
    }
  },
  { timestamps: true }
);

const StudentAuthority = mongoose.model("StudentAuthority", StudentAuthoritiesSchema);
export default StudentAuthority;
