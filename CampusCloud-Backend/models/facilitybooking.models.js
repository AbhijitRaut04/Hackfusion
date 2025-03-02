import mongoose from "mongoose";

const FacilityBookingSchema = new mongoose.Schema(
  {
    facility: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Facility",
      required: true,
    },
    bookedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true,
    },
    date: {
      type: Date,
      required: true,
    },
    timeSlot: {
      type: String,
      required: true,
      enum: [
        "10:00 AM - 11:00 AM",
        "11:00 AM - 12:00 PM",
        "12:00 PM - 01:00 PM",
        "01:00 PM - 02:00 PM",
        "02:00 PM - 03:00 PM",
        "03:00 PM - 04:00 PM",
        "04:00 PM - 05:00 PM",
        "05:00 PM - 06:00 PM",
        "07:00 PM - 08:00 PM",
        "08:00 PM - 09:00 PM",
        "09:00 PM - 10:00 PM",
        "10:00 PM - 11:00 PM",
        "11:00 PM - 12:00 AM",
        "12:00 AM - 01:00 AM",
      ],
    },
    status: {
      type: String,
      enum: ["Pending", "Approved", "Rejected"],
      default: "Pending",
    },
    approvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "FacultyAuthority", // References faculty who approves the booking
    },
    reasonForRejection: {
      type: String,
      trim: true,
    }
  },
  { timestamps: true }
);

const FacilityBooking = mongoose.model("FacilityBooking", FacilityBookingSchema);
export default FacilityBooking;
