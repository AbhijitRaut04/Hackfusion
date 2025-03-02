import 'package:campus_cloud/controller/electionController.dart';
import 'package:campus_cloud/views/election/verificationPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoteNowPage extends StatefulWidget {
  const VoteNowPage({super.key});

  @override
  State<VoteNowPage> createState() => _VoteNowPageState();
}

class _VoteNowPageState extends State<VoteNowPage> {
  ElectionController controller = Get.find<ElectionController>();
  int? selectedPositionIndex;
  int? selectedCandidateIndex;

  void proceedToVerification() {
    if (selectedPositionIndex == null || selectedCandidateIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a position and a candidate!")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationPage(
          position: selectedPositionIndex!,
          candidate: selectedCandidateIndex!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> positions = controller.candidates.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Cast Your Vote")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Position:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: selectedPositionIndex,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              items: positions.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPositionIndex = value;
                  selectedCandidateIndex = null;
                });
              },
              hint: Text("Choose a position"),
            ),
            SizedBox(height: 16),

            if (selectedPositionIndex != null) ...[
              Text("Select Candidate:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Column(
                children: controller.candidates[positions[selectedPositionIndex!]]!.asMap().entries.map((entry) {
                  return RadioListTile<int>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: selectedCandidateIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedCandidateIndex = value;
                      });
                    },
                    activeColor: Colors.blueAccent,
                  );
                }).toList(),
              ),
            ],

            Spacer(),

            ElevatedButton(
              onPressed: proceedToVerification,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Proceed"),
            ),
          ],
        ),
      ),
    );
  }
}
