import mongoose from "mongoose";

const RequestSchema = new mongoose.Schema(
  {
    from: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true,
    },
    to: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      refPath: "toModel",
    },
    toModel: {
      type: String,
      required: true,
      enum: ["FacultyAuthority", "StudentAuthority"],
    },
    application: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      refPath: "applicationModel",
    },
    applicationModel: {
      type: String,
      required: true,
      enum: ["FacilityBooking", "Application"],
    },
  },
  { timestamps: true }
);

const Request = mongoose.model("Request", RequestSchema);
export default Request;
