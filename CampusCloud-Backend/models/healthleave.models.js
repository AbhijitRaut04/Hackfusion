import mongoose from "mongoose";

const HealthLeaveNotificationSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true,
    },
    mailTo: {
      type:String
    },
    startDate: {
      type: Date,
    },
    endDate: {
      type: Date,
    },
    title: {
      type: String,
    },
  },
  { timestamps: true }
);

const HealthLeaveNotification = mongoose.model("HealthLeaveNotification", HealthLeaveNotificationSchema);
export default HealthLeaveNotification;
