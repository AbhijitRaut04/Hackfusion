import 'package:campus_cloud/routes/RouteNames.dart';
import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SlotSelectionPage extends StatefulWidget {
  final String facility;
  final DateTime date;

  const SlotSelectionPage({super.key, required this.facility, required this.date});

  @override
  State<SlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends State<SlotSelectionPage> {
  List<String> bookedSlots = [];
  List<String> availableSlots = [
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
  ];
  Set<String> selectedSlots = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  Future<void> fetchSlots() async {
    final url = Uri.parse("${dotenv.env['BACKEND_URL']}/facility");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "date": widget.date.toIso8601String().split('T')[0],
        "facilityName": widget.facility
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(" hello $data");
      setState(() {
        bookedSlots = data.containsKey('times') ? List<String>.from(data['times']) : [];
        isLoading = false;
      });
    } else {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        bookedSlots = data['message'] == "Facility not found" ? [] : bookedSlots;
        isLoading = false;
      });
    }
  }
  Future<void> bookSlots() async {
    final url = Uri.parse("${dotenv.env['BACKEND_URL']}/facility/book");
    final box=GetStorage();
    final authToken = box.read("authToken"); // Retrieve token from storage

    if (authToken == null) {
      print("Error: No auth token found");
      return;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Pass token in Authorization header
      },
      body: jsonEncode({
        "date": widget.date.toIso8601String().split('T')[0],
        "facilityName": widget.facility, // Use facility name as sub-facility
        "timeSlots": selectedSlots.toList()
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        bookedSlots.addAll(selectedSlots);
        selectedSlots.clear();
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar("Success", "${widget.facility} booked successfully");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book slots: ${response.body}')),
      );
    }
  }

  void toggleSlot(String slot) {
    setState(() {
      if (selectedSlots.contains(slot)) {
        selectedSlots.remove(slot);
      } else {
        selectedSlots.add(slot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Book ${widget.facility}'),
          actions: [
            TextButton(
              onPressed: (){
                Get.toNamed(RouteNames.AllBookings,arguments: {'date':widget.date,'facility':widget.facility});
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor: WidgetStatePropertyAll(Color(0xFF023D84))),
              child: Text("All Bookings"),)
          ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          const Text('Select Time Slots:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                String slot = availableSlots[index];
                bool isBooked = bookedSlots.contains(slot);
                return ListTile(
                  title: Text(slot),
                  tileColor: isBooked
                      ? Colors.red.withOpacity(0.5) // Mark booked slots red
                      : selectedSlots.contains(slot)
                      ? Colors.green.withOpacity(0.5) // Mark selected slots green
                      : null,
                  onTap: isBooked ? null : () => toggleSlot(slot),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: selectedSlots.isNotEmpty ? bookSlots : null,
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
