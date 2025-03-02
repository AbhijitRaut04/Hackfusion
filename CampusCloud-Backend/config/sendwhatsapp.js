import axios from 'axios';

const accessToken = process.env.WHATSAPP_ACCESS_TOKEN;
const phoneNumberId = process.env.PHONE_NUMBER_ID;

export const sendWhatsappMessage = async (req, res) => {
    try {
        const { recipient } = req.body;

        if (!recipient) {
            return res.status(400).json({ message: "Recipient phone number is required" });
        }

        const response = await axios.post(`https://graph.facebook.com/v17.0/${phoneNumberId}/messages`, {
            messaging_product: "whatsapp",
            to: recipient,
            type: "text",
            text: { body: "Hello from WhatsApp API!" }
        }, {
            headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json'
            }
        });

        return res.status(200).json(response.data);

    } catch (error) {
        console.error("WhatsApp API Error:", error?.response?.data || error.message);
        return res.status(500).json({ 
            message: "Failed to send WhatsApp message", 
            error: error?.response?.data || error.message 
        });
    }
};
