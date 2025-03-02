import mongoose from "mongoose";

const CheatingRecordSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    proof: [
      {
        type: String, // Can store URLs to uploaded image or document proofs
        trim: true,
      },
    ],
    caughtBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Faculty",
      // required: true,
    },
  },
  { timestamps: true }
);

const CheatingRecord = mongoose.model("CheatingRecord", CheatingRecordSchema);
export default CheatingRecord;
