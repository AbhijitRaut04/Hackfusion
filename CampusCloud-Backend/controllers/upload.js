import { v2 as cloudinary } from "cloudinary";
import fs from 'fs'
import dotenv from 'dotenv'
dotenv.config({ path: './.env' })

//configure
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});


export const imageUpload = async (req, res) => {
    try {
        if (!req.file) return res.status(400).send({message: "File not found"})
        const filePath = req.file.path;

        if (!filePath) return res.status(404).send({ message: "No file found" });

        const response = await cloudinary.uploader.upload(filePath, { resource_type: "auto" });
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
        return res.status(200).send({ imageUrl: response.secure_url });
        
    } catch (error) {
        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }
        return res.status(500).send({ Error: error.message, message: "Image upload failed" });
    }
};

export const deleteImage = async (req, res) => {
    try {
      const { public_id } = req.body; // You should send the public_id from the request body
      if (!public_id) {
        return res.status(400).json({ message: 'No image public_id provided.' });
      }
  
      // Delete the image using the public_id
      const result = await v2.uploader.destroy(public_id);
      
      // If successful, return a response
      return res.status(200).json({
        message: 'Image deleted successfully!',
        result,
      });
    } catch (error) {
      return res.status(500).json({
        message: 'Failed to delete image from Cloudinary.',
        error: error.message,
      });
    }
  };

