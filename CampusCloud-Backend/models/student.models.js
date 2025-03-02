import mongoose from "mongoose";

const StudentSchema = new mongoose.Schema(
  {
    registrationNo: {
      type: String,
      required: true,
      unique: true, 
    },
    name: {
      type: String,
      required: true,
    },
    profilePhoto:{
      type: String,
      default: ""
    },
    idPhoto:{
      type:String
    },
    blockchainAddress: {
      type: String
    },
    email: {
      type: String,
      required: true,
      unique: true, 
      match: [/^\S+@\S+\.\S+$/, "Please enter a valid email address"],
    },
    password: {
      type: String,
      required: true,
    },
    department: {
      type: String,
      // enum: ["CSE", "IT", "EXTC", "INST", "ELE", "CHE", "CIVIL", "MECH", "PROD", "TEXT"],
      required: true, 
    },
    year: {
      type: Number,
    },
    phone: {
      type: String,
    //   match: [/^\d{10}$/, "Please enter a valid 10-digit phone number"],
    },
    dob: {
      type: String,
      required: false,
    },
    bloodGroup:{
      type: String,
      required: false,
    },
    address: {
      type: String,
    },
  },
  { timestamps: true }
);

const Student = mongoose.model("Student", StudentSchema);
export default Student;
