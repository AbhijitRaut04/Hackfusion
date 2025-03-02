import 'dart:convert';

import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../routes/RouteNames.dart';
import '../widgets/imageAvatar.dart';
import '../writeApplication/writeApplication.dart';


class DrawerView extends StatelessWidget {
  DrawerView({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(box.read("name") ?? "Student Name"),
              accountEmail: Text(box.read("email") ?? "2022bcsxxx@sggs.ac.in"),
              currentAccountPicture: ImageAvatar(radius: 35,url: box.read("profilePhoto"),),
            ),
            ListTile(
              title: const Text("Home"),
              leading: const Icon(Icons.home),
              onTap: (){},
            ),
            ListTile(
              title: const Text("Complaints"),
              leading: const Icon(Icons.report_problem),
              onTap: (){
                Get.toNamed(RouteNames.Complaint);
              },
            ),
            ListTile(
              title: const Text("Write Application"),
              leading: const Icon(Icons.abc_outlined),
              onTap: (){
                Get.toNamed(RouteNames.WriteApplication);
              },
            ),
            ListTile(
              title: const Text("Cheating Students"),
              leading: const Icon(Icons.pending_actions),
              onTap: (){
                Get.toNamed(RouteNames.CheatingStudents);
              },
            ),
            ListTile(
              title: const Text("Election"),
              leading: const Icon(Icons.pending_actions),
              onTap: () async {
                showSnackBar("No Ongoing Election", "Elections not started yet");
                // try {
                //   final response = await http.get(Uri.parse("http://192.168.32.42:5000/api/elections"));
                //
                //   if (response.statusCode == 200) {
                //     final data = json.decode(response.body);
                //     final election = data["election"];
                //
                //     DateTime startDate = DateTime.parse(election["startDate"]);
                //     DateTime endDate = DateTime.parse(election["endDate"]);
                //     DateTime today = DateTime.now();
                //
                //     if (today.isBefore(startDate)) {
                //       Get.toNamed("/noelections"); // No election started
                //     } else if (today.isAfter(endDate)) {
                //       Get.toNamed("/electionresults"); // Show results
                //     } else {
                //       Get.toNamed("/election"); // Voting is ongoing
                //     }
                //   } else {
                //     throw Exception("Failed to load election data");
                //   }
                // } catch (e) {
                //   print("Error fetching election data: $e");
                // }
              },
            ),
            ListTile(
              title: const Text("Facility Booking"),
              leading: const Icon(Icons.pending_actions),
              onTap: (){
                Get.toNamed(RouteNames.CampusBooking);
              },
            ),

            ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: (){},
            ),
            ListTile(
              title: const Text("About"),
              leading: const Icon(Icons.info),
              onTap: (){},
            ),
            const ListTile(
              title: Text("Cloud Campus v1"),
              subtitle: Text("Developed with ❤️ by Frontman 404"),

            ),
          ],
        )
    );
  }
}
