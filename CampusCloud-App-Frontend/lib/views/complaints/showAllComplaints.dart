import 'package:campus_cloud/controller/cheatingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/complaintsController.dart';
import '../widgets/complaintCard.dart';
import '../widgets/loading.dart';
import '../widgets/cheatingCard.dart';

class StudentsComplaints extends StatefulWidget {
  const StudentsComplaints({super.key});

  @override
  State<StudentsComplaints> createState() => _StudentsComplaintsState();
}

class _StudentsComplaintsState extends State<StudentsComplaints> {
  final ComplaintsController controller = Get.put(ComplaintsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Loading();
                }
                if (controller.complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      "No complaints!",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.complaints.length,
                  itemBuilder: (BuildContext context, int index) {
                    var complaint = controller.complaints[index];
                    return ComplaintCard(
                      subject: complaint.title ?? "Subject to complaint",
                      desc: complaint.description ?? "Description of complaint",
                      to: complaint.complaintTo ?? [],
                      attachments: complaint.attachments ?? [],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
