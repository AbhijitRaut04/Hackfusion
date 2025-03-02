import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ElectionResults extends StatefulWidget {
  const ElectionResults({super.key});

  @override
  State<ElectionResults> createState() => _ElectionResultsState();
}

class _ElectionResultsState extends State<ElectionResults> {
  List<dynamic> electionResults = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchElectionResults();
  }

  Future<void> fetchElectionResults() async {
    final Uri url = Uri.parse("http://192.168.32.63:5005/allResults"); // Update with correct API URL

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          setState(() {
            electionResults = data["allPositionResults"];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        print(response.body);
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Election Results"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text("Failed to load results!"))
          : SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: electionResults.map((position) {
            List<dynamic> candidates = position["candidates"];
            candidates.sort((a, b) => int.parse(b["voteCount"]).compareTo(int.parse(a["voteCount"])));
            String winnerId = candidates.first["candidateId"];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position["positionTitle"],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: candidates.map((candidate) {
                        bool isWinner = candidate["candidateId"] == winnerId;
                        return ListTile(
                          title: Text(
                            candidate["candidateName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isWinner ? Colors.green : Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "Votes: ${candidate["voteCount"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isWinner ? Colors.green : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
