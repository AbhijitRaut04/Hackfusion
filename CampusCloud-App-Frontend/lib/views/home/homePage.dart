import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/RouteNames.dart';
import '../widgets/imageCarousal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFloatingVisible = true;
  var list = [
    "https://res.cloudinary.com/dkjtmsfhz/image/upload/v1740255983/5_hl3ns3.jpg",
    "https://res.cloudinary.com/dkjtmsfhz/image/upload/v1740255850/1_ixagdk.jpg",
    "https://res.cloudinary.com/dkjtmsfhz/image/upload/v1740255849/3_dhv4yw.jpg",
    "https://res.cloudinary.com/dkjtmsfhz/image/upload/v1740255849/4_ggzrsv.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFloatingVisible
          ? FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNames.Chatbot);
        },
        child: const Icon(Icons.chat_outlined),
      )
          : null,
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCarousal(
                urlImages: List.generate(4, (index) => list[index]),
              ),
              SizedBox(height: 20),
              Text(
                "Announcements",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Important Notice",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Campus maintenance will take place on Sunday. WiFi facilities may be unavailable.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Important Notice",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Next saturday will be a working day for the college",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                "Shortcuts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildShortcut(Icons.account_circle_rounded, "Digital ID", RouteNames.IdProof),
                  _buildShortcut(Icons.library_books, "Cheaters List", RouteNames.CheatingStudents),
                  _buildShortcut(Icons.group, "Chat with AI", RouteNames.Chatbot),
                  _buildShortcut(Icons.settings, "Settings", RouteNames.Settings),
                  _buildShortcut(Icons.book, "Facility Booking", RouteNames.CampusBooking),
                  _buildShortcut(Icons.medical_information_outlined, "Appointment", RouteNames.DispensaryAppointment),
                  _buildShortcut(Icons.headset_mic_rounded, "Complaints", RouteNames.StudentsComplaints),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcut(IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
