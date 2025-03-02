import Election from "../models/election.models.js";
import axios from 'axios';
// @desc    Create a new election
// @route   POST /api/elections
// @access  Private (Faculty only)
export const createElection = async (req, res) => {
  try {
    const { electionName, description, date } = req.body;

    const newElection = new Election({
      electionName,
      description,
      date,
    });

    await newElection.save();
    res.status(200).json({ message: "Election created successfully", election: newElection });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getElectionInfo = async (req, res) => {
  try {
    const election = await Election.findById("67ba7d1370096377beb26435");
    if (!election) res.status(404).send({ message: "Election not found" });
    res.status(200).send({ election });
  } catch (error) {
    res.status(500).send({ message: error.message })
  }
}

export const getElectionDetails = async (req, res) => {
  try {
    const response = await axios.get(`${process.env.BLOCKCHAIN_URL}`);
    const data = response.data;
    console.log(data);
    res.status(200).json({ message: "Election created successfully", data });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

export const voteForElection = async (req, res) => {
  try {
    const { positionId, candidateId } = req.body;
    const voterAddress = req.student.blockchainAddress;

    const result = await axios.post('http://192.168.40.63:5000/vote', { positionId, candidateId, voterAddress })
      .then((res) => {
        return res;
      })

    res.status(200).json({ message: "Voted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}