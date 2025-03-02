import 'package:campus_cloud/controller/electionController.dart';
import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VerificationPage extends StatefulWidget {
  final int position;
  final int candidate;

  const VerificationPage({super.key, required this.position, required this.candidate});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  ElectionController controller = Get.find<ElectionController>();
  TextEditingController passwordController = TextEditingController();


  void submitVote() {
    if (controller.imageFile.value==null) {
      showSnackBar("Selfie Required", "Please capture a selfie before submitting");
      return;
    }
    else if (passwordController.text.isEmpty) {
      showSnackBar("Password Required", "Please enter your password!");
      return;
    }
    controller.vote(context,widget.position,widget.candidate);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Vote for ${widget.candidate} as ${widget.position} submitted!")),
    // );
    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification")),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Enter Password to Confirm Vote", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your password",
                  ),
                ),
                SizedBox(height: 24),
                Text("Take a selfie for verification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.captureSelfie();
                  },
                  child: Text("Capture Selfie"),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: submitVote,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Submit Vote"),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isVerifying.value) {
              return Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
