import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentSlotSelectionPage extends StatefulWidget {
  final DateTime date;
  final String symptoms;

  const AppointmentSlotSelectionPage({super.key, required this.date, required this.symptoms});

  @override
  State<AppointmentSlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends State<AppointmentSlotSelectionPage> {
  List<String> bookedSlots = [];
  List<String> availableSlots = [
    "10:00 - 10:15",
    "10:15 - 10:30",
    "10:30 - 10:45",
    "10:45 - 11:00",
    "11:00 - 11:15",
  ];
  String? selectedSlot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookedSlots();
  }

  Future<void> fetchBookedSlots() async {
    final box = GetStorage();
    final authToken = box.read('authToken'); // Retrieve token from GetStorage

    final url = Uri.parse(
      "${dotenv.env['BACKEND_URL']}/appointments/get-booked-slots?date=${widget.date.toIso8601String().split('T')[0]}");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken', // Include token in headers
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (data.containsKey('message') && data['message'] == "No bookings found for this date") {
          bookedSlots = [];
        } else {
          bookedSlots = data.containsKey('times') ? List<String>.from(data['times']) : [];
        }
        isLoading = false;
      });
    } else {
      setState(() {
        bookedSlots = [];
        isLoading = false;
      });
    }
  }

  Future<void> bookAppointment() async {
    if (selectedSlot == null) return;
    final url = Uri.parse("${dotenv.env['BACKEND_URL']}/appointments/book-slot");
    var box = GetStorage();
    String? token = box.read('authToken');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "date": widget.date.toIso8601String().split('T')[0],
        "time": selectedSlot,
        "symptoms": widget.symptoms
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        bookedSlots.add(selectedSlot!);
        selectedSlot = null;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),

      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment: ${response.body}')),
      );
    }
  }

  void selectSlot(String slot) {
    setState(() {
      selectedSlot = selectedSlot == slot ? null : slot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment on ${widget.date.toLocal()}'.split(' ')[0])),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          const Text('Select Time Slot:',
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
                      ? Colors.red.withOpacity(0.5)
                      : selectedSlot == slot
                      ? Colors.green.withOpacity(0.5)
                      : null,
                  onTap: isBooked ? null : () => selectSlot(slot),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: selectedSlot != null
                ? () => bookAppointment() // Wrap the async function inside an anonymous function
                : null,
            child: const Text('Confirm Appointment'),
          ),
          const SizedBox(height: 20), // Add spacing at the bottom
        ],
      ),
    );
  }
}