import Request from "../models/requests.models.js";

// Create a new request
export const createRequest = async (req, res) => {
  try {
    const { from, to, toModel, application, applicationModel } = req.body;

    const newRequest = new Request({
      from,
      to,
      toModel,
      application,
      applicationModel,
    });

    const savedRequest = await newRequest.save();
    res.status(200).json(savedRequest);
  } catch (error) {
    res.status(500).json({ error: "Failed to create request", details: error.message });
  }
};

// Get all requests
export const getAllRequests = async (req, res) => {
  try {
    const requests = await Request.find()
      .populate("from", "name email")
      .populate("to", "name email")
      .populate("application");
    res.status(200).json(requests);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch requests", details: error.message });
  }
};

// Get a single request by ID
export const getRequestById = async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)
      .populate("from", "name email")
      .populate("to", "name email")
      .populate("application");
    
    if (!request) {
      return res.status(404).json({ error: "Request not found" });
    }

    res.status(200).json(request);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch request", details: error.message });
  }
};

// Delete a request
export const deleteRequest = async (req, res) => {
  try {
    const deletedRequest = await Request.findByIdAndDelete(req.params.id);

    if (!deletedRequest) {
      return res.status(404).json({ error: "Request not found" });
    }

    res.status(200).json({ message: "Request deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete request", details: error.message });
  }
};
