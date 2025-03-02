import 'dart:async';
import 'package:campus_cloud/controller/electionController.dart';
import 'package:campus_cloud/routes/RouteNames.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Election extends StatefulWidget {
  const Election({super.key});

  @override
  State<Election> createState() => _ElectionState();
}

class _ElectionState extends State<Election> {
  ElectionController controller = Get.put(ElectionController());
  DateTime electionDate = DateTime(2025, 3, 15, 18, 00); // Hardcoded Election Date
  Duration timeLeft = Duration();
  Timer? countdownTimer;

  // final Map<String, List<String>> candidates = {
  //   "President": ["Alice Johnson", "Bob Smith", "Charlie Brown"],
  //   "Vice President": ["David Lee", "Eva Green"],
  //   "Secretary": ["Frank White", "Grace Adams"],
  //   "Treasurer": ["Harry Clark", "Isabella Martin"]
  // };

  @override
  void initState() {
    super.initState();
    updateCountdown();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) => updateCountdown());
  }

  void updateCountdown() {
    setState(() {
      timeLeft = electionDate.difference(DateTime.now());
      if (timeLeft.isNegative) {
        countdownTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) return "Elections Over";
    return "${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("College Elections")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Elections End In",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formatDuration(timeLeft),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Loading Indicator when fetching data
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: ListView(
                  children: controller.candidates.keys.map((position) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(position, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.candidates[position]!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      child: Text(controller.candidates[position]![index][0]), // Initials
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      controller.candidates[position]![index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.toNamed(RouteNames.Voting),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)), // Navigate to Vote Page
              child: Text("Vote Now"),
            ),
          ],
        ),
      ),
    );
  }
}