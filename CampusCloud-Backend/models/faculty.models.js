import mongoose from "mongoose";

const FacultySchema = new mongoose.Schema(
  {
    registrationNo: {
      type: String,
      required: true,
      unique: true, // Ensures each faculty has a unique registration number
      trim: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true, // Each faculty should have a unique email
      match: [/^\S+@\S+\.\S+$/, "Invalid email format"],
    },
    password: {
      type: String,
      required: true,
      minlength: 6, // Enforces password security
    },
    department: {
      type: String,
      trim: true,
    },
    phone: {
      type: String,
      match: [/^\d{10}$/, "Phone number must be 10 digits"],
    },
  },
  { timestamps: true }
);

const Faculty = mongoose.model("Faculty", FacultySchema);
export default Faculty;
