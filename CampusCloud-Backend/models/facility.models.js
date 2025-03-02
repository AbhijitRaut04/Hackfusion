import mongoose from "mongoose";

const FacilitySchema = new mongoose.Schema(
  {
    facilityName: {
      type: String,
      required: true,
    },
    bookings: [{
      date: {
        type: Date
      },
      slots: [{
        time: {
          type: String
        },
        bookedBy: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Student"
        }
      }]
    }]
  },
  { timestamps: true }
);

const Facility = mongoose.model("Facility", FacilitySchema);
export default Facility;
