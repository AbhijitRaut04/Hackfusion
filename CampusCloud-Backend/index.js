import express from "express";
import cors from "cors";
import studentRoutes from "./routes/student.routes.js";
import healthLeaveRoutes from "./routes/healthleave.routes.js";
import facultyRoutes from "./routes/faculty.routes.js";
import facilityBookings from "./routes/facilitybooking.routes.js";
import complaintRoutes from "./routes/complaint.routes.js";
import electionRoutes from "./routes/election.routes.js";
import cheatingRoutes from "./routes/cheating.routes.js";
import notificationRoutes from "./routes/notification.routes.js";
import studentAuthorityRoutes from "./routes/studentauthorities.routes.js"
import facultyAuthorityRoutes from "./routes/facultyauthorities.routes.js"
import appointmentRoutes from "./routes/appointment.routes.js"
import applicationRoutes from "./routes/application.routes.js"

import connectDB from "./config/db.js";
import { upload } from "./middlewares/multer.js";
import { deleteImage, imageUpload } from "./controllers/upload.js";
import dotenv from 'dotenv';
import cookieParser from "cookie-parser";

import { sendEmail } from "./config/sendemail.js";
import { sendWhatsappMessage } from "./config/sendwhatsapp.js";
import { generateOTP } from "./config/generateOTP.js";
import { generatePDF } from "./config/generatePdf.js";
dotenv.config()


const app = express();
const PORT = process.env.PORT || 5000;


app.use(cors());
app.use(cookieParser())
app.use(express.json());
app.use(express.static("public"));


app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true })); 

connectDB();

// Routes
app.get("/", (req, res) => {
  res.send("Server is running!");
});

app.post("/api/image-upload", upload.single("photo"), imageUpload);

app.post('/api/send-email', (req, res) => {
  try {
    const { to, subject, message } = req.body;
    sendEmail(to, subject, message)
    res.status(200).send({ message: "Email sent successfully!" });
  } catch (error) {
    res.status(500).send({ message: error.message })
  }
});

app.post('/api/send-otp', (req, res) => {
  try {
    const { to } = req.body;

    if(!to.endsWith("@sggs.ac.in")) res.status(403).send({message: "Invalid Email for user"})

    let otp = generateOTP();
    let subject = "Registration for cloud campus"
    let message = `<p>You have attempted to register at CloudCampus</p> \n\n Your OTP is  <h1>${otp}</h1>\n\n\n\n If not you then ignore.`
    sendEmail(to, subject, message)
    res.status(200).send({ message: "Email sent successfully!", otp });
  } catch (error) {
    res.status(500).send({ message: error.message })
  }
});

app.post('/api/send-whatsapp', sendWhatsappMessage);

app.delete('/api/delete', deleteImage);

// Example Usage
const htmlContent = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formal Letter</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            padding: 20px;
            border: 2px solid #000;
            max-width: 700px;
        }
        .header {
            text-align: left;
            font-size: 14px;
        }
        .recipient {
            margin-top: 20px;
            font-size: 16px;
        }
        .subject {
            margin-top: 20px;
            font-weight: bold;
            font-size: 18px;
            text-decoration: underline;
        }
        .body {
            margin-top: 20px;
            font-size: 16px;
            text-align: justify;
        }
        .signature-section {
            margin-top: 40px;
            display: flex;
            justify-content: space-between;
        }
        .signature {
            text-align: center;
        }
        .signature img {
            width: 120px; 
            height: auto;
        }
    </style>
</head>
<body>

    <div class="header">
        <p>Your Name</p>
        <p>Your Address</p>
        <p>Your City, Postal Code</p>
        <p>Your Email</p>
        <p>Date: <span id="date"></span></p>
    </div>

    <div class="recipient">
        <p>Recipient's Name</p>
        <p>Recipient's Position</p>
        <p>Company/Institution Name</p>
        <p>Recipient's Address</p>
    </div>

    <div class="subject">
        Subject: Formal Request/Application
    </div>

    <div class="body">
        <p>Dear [Recipient's Name],</p>

        <p>I hope this letter finds you in good health and high spirits. I am writing to formally request [mention your request or purpose]. The reason for my request is [explain the reason clearly and concisely].</p>

        <p>I kindly seek your approval/assistance in this matter and would be grateful for any consideration you provide. If any further details or documents are required, please let me know at your convenience.</p>

        <p>Looking forward to your positive response.</p>

        <p>Sincerely,</p>
    </div>

    <div class="signature-section">
        <div class="signature">
            <img src="SIGNATURE_IMAGE_URL_1" alt="Signature 1">
            <p>Signer 1 Name</p>
            <p>Signer 1 Position</p>
        </div>
        <div class="signature">
            <img src="SIGNATURE_IMAGE_URL_2" alt="Signature 2">
            <p>Signer 2 Name</p>
            <p>Signer 2 Position</p>
        </div>
    </div>

    <script>
        document.getElementById("date").textContent = new Date().toLocaleDateString();
    </script>

</body>
</html>


`;

// generatePDF(htmlContent, "./public/temp/output.pdf");



app.use("/api/students", studentRoutes);
app.use("/api/faculty", facultyRoutes);
app.use("/api/facility", facilityBookings);
app.use("/api/complaints", complaintRoutes);
app.use("/api/elections", electionRoutes);
app.use("/api/cheatings", cheatingRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/student-authorities", studentAuthorityRoutes);
app.use("/api/faculty-authorities", facultyAuthorityRoutes);
app.use('/api/healthleaves', healthLeaveRoutes)
app.use('/api/applications', applicationRoutes)
app.use('/api/appointments', appointmentRoutes)

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
