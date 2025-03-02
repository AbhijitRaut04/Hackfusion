import mongoose from "mongoose";

const ApplicationSchema = new mongoose.Schema(
  {
    from: {
      type: String,
      required: true,
    },
    title: {
      type: String,
    },
    to: [{
      authority: {
        type: String,
        required: true,
      },
      status: {
        type: String,
        enum: ["approved", "rejected", "pending"]
      }
    }],
    isApproved: {
      type: Boolean,

    },
    body: {
      type: String
    },
    file: {
      type: String
    },
    priority: {
      type: String,
      enum: ["low", "medium", "high"],
      default: "high"
    }
  },
  { timestamps: true }
);

const Application = mongoose.model("Application", ApplicationSchema);
export default Application;
