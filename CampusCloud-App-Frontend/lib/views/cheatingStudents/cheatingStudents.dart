import 'package:campus_cloud/controller/cheatingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/loading.dart';
import '../widgets/cheatingCard.dart';

class CheatingStudents extends StatefulWidget {
  const CheatingStudents({super.key});

  @override
  State<CheatingStudents> createState() => _CheatingStudentsState();
}

class _CheatingStudentsState extends State<CheatingStudents> {
  final CheatingController controller = Get.put(CheatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cheating Students"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Hall of Shame\nThe Price of Dishonesty",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Success earned through hard work lasts a lifetime. Cheating only brings temporary gains and permanent disgrace. This list serves as a reminder that integrity matters.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Loading();
                }
                if (controller.cheatings.isEmpty) {
                  return const Center(
                    child: Text(
                      "No cheaters yet!",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.cheatings.length,
                  itemBuilder: (BuildContext context, int index) {
                    var cheater = controller.cheatings[index];
                    return CheatingCard(
                      name: cheater.student?.name ?? "Unknown",
                      registrationNumber: cheater.student?.email ?? "N/A",
                      branch: cheater.title ?? "N/A",
                      description: cheater.description ?? "No details available",
                      proof: cheater.proof![0],
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
