import nodemailer from "nodemailer";

export const sendEmail = async (to, subject, message) => {

    if (!to || !subject || !message) {
        return { error: "Missing required fields" };
    }

    try {
        // Configure mail transporter
        const transporter = nodemailer.createTransport({
            service: "gmail", // Or use another email provider
            auth: {
                user: process.env.EMAIL_USER, // Your email
                pass: process.env.EMAIL_PASS, // Your email app password
            },
        });

        // Email options
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to,
            subject,
            html: message,
        };

        // Send email
        const info = await transporter.sendMail(mailOptions);
        console.log("Email sent: ", info.response);

        return { success: "Email sent successfully!" };
    } catch (error) {
        console.error("Error sending email:", error);
        return { error: "Failed to send email" };
    }
}