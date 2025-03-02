import 'package:flutter/material.dart';
import 'appointmentSlotSelection.dart';

class DispensaryAppointmentPage extends StatefulWidget {
  const DispensaryAppointmentPage({super.key});

  @override
  State<DispensaryAppointmentPage> createState() => _DispensaryAppointmentPageState();
}

class _DispensaryAppointmentPageState extends State<DispensaryAppointmentPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController symptomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispensary Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 10),
            const Text('Enter Symptoms:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: symptomsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe your symptoms',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentSlotSelectionPage(
                      date: selectedDate,symptoms: symptomsController.text,
                    ),
                  ),
                );
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
