import 'package:flutter/material.dart';
import 'slotSelection.dart';

void main() {
  runApp(const FacilityBookingApp());
}

class FacilityBookingApp extends StatelessWidget {
  const FacilityBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facility Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BookingPage(),
    );
  }
}

// Page 1: Select Facility and Sub-Facility
class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedFacility;
  String? selectedSubFacility;
  DateTime selectedDate = DateTime.now();

  final Map<String, List<String>> subFacilities = {
    'Classroom': ['CSE 1', 'CSE 2', 'IT 1','CE 1','Text 1'],
    'Lab': ['ML Lab', 'CSE Lab 1', 'CSE Lab2','CCF Lab',"CVDV Lab","A4 Complex"],
    'Auditorium': ['Auditorium'],
    'Playground':["Basketball Court","Tennis Court","VolleyBall Court","Kabbadi Court"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facility Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Facility:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedFacility,
              hint: const Text('Choose Facility'),
              isExpanded: true,
              items: subFacilities.keys.map((facility) {
                return DropdownMenuItem(
                  value: facility,
                  child: Text(facility),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFacility = value;
                  selectedSubFacility = null;
                });
              },
            ),
            if (selectedFacility != null && subFacilities[selectedFacility] != null) ...[
              const SizedBox(height: 10),
              const Text('Select Sub-Facility:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedSubFacility,
                hint: const Text('Choose Sub-Facility'),
                isExpanded: true,
                items: subFacilities[selectedFacility]!.map((subFacility) {
                  return DropdownMenuItem(
                    value: subFacility,
                    child: Text(subFacility),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubFacility = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 10),
            const Text('Select Date:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text("${selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedFacility != null && selectedSubFacility != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SlotSelectionPage(
                      facility: selectedSubFacility!,
                      date: selectedDate,
                    ),
                  ),
                );
              }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 2: Select Time Slots
