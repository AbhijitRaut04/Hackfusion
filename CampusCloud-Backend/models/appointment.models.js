import mongoose from "mongoose";

const AppointmentSchema = new mongoose.Schema(
    {
        date: {
            type: Date
        },
        slots: [{
            time: {
                type: String
            },
            bookedBy: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Student'
            },
            symptoms: {
                type: String,
                required: true,
            }
        }]
    },
    { timestamps: true }
);

const Appointment = mongoose.model("Appointment", AppointmentSchema);
export default Appointment;
