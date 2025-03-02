import Appointment from "../models/appointment.models.js";

// Book an appointment slot
export const bookSlot = async (req, res) => {
  try {
    const { date, time, symptoms } = req.body;
    const studentId = req.student?._id; 

    if (!date || !time || !symptoms) {
      return res.status(400).json({ message: "Date, time, and symptoms are required" });
    }

    let appointment = await Appointment.findOne({ date });

    if (!appointment) {
      appointment = new Appointment({
        date,
        slots: [{ time, bookedBy: studentId, symptoms }]
      });
    } else {
      const existingSlot = appointment.slots.find(slot => slot.time === time);

      if (existingSlot) {
        return res.status(400).json({ message: "Slot already booked" });
      }

      appointment.slots.push({ time, bookedBy: studentId, symptoms });
    }

    await appointment.save();
    res.status(200).json({ message: "Appointment booked successfully", appointment });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getAppointmentsByStudent = async (req, res) => {
  try {
    const { studentId } = req.params;

    // Find all appointments where the student has booked a slot
    const appointments = await Appointment.find({ "slots.bookedBy": studentId })
      .populate("slots.bookedBy", "name email") // Populate student details
      .exec();

    res.status(200).json(appointments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getAllAppointments = async (req, res) => {
  try {
    const today = new Date();
    // today.setHours(0, 0, 0, 0); // Set time to start of today

    // Find appointments where date is today or in the future
    const appointments = await Appointment.find({ date: { $gte: today } });

    return res.status(200).send({ appointments });
  } catch (error) {
    res.status(500).send({ message: error.message });
  }
};


// Get booked slots for a particular date
export const getBookedSlots = async (req, res) => {
  try {
    const { date } = req.query || req.body;

    if (!date) {
      return res.status(400).json({ message: "Date is required" });
    }

    const appointment = await Appointment.findOne({ date }).populate("slots.bookedBy", "name email department");

    if (!appointment) {
      return res.status(404).json({ message: "No bookings found for this date" });
    }

    let times = appointment.slots.map((a) => a.time)

    res.status(200).json({ slots: appointment.slots, times });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
