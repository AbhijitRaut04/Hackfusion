import mongoose from "mongoose";

const FacultyAuthoritiesSchema = new mongoose.Schema(
  {
    faculty: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Faculty",
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
    role: {
      type: String
    },
    department: {
      type: String
    },
    signature: {
      type: String
    }
  },
  { timestamps: true }
);

const FacultyAuthority = mongoose.model("FacultyAuthority", FacultyAuthoritiesSchema);
export default FacultyAuthority;
