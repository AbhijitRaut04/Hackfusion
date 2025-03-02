import bcryptjs from "bcryptjs";

export const isPasswordCorrect = async (req, res, next) => {
  try {
    const { password } = req.body; // Get password from request body

    if (!password) {
      return res.status(400).json({ message: "Password is required to vote." });
    }
    // Compare password
    const isMatch = await bcryptjs.compare(password, req.student.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Incorrect password." });
    }

    next(); 
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

export const validateSelfie = async (req, res, next) => {
  try {

    next(); 
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
}
