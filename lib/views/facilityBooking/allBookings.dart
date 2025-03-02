import 'package:campus_cloud/controller/facilityBookingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllBookings extends StatefulWidget {
  const AllBookings({super.key});

  @override
  State<AllBookings> createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {
  FacilityBookingController controller = Get.put(FacilityBookingController());
  late String date;
  late String facility;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    date = DateFormat('dd-MM-yyyy').format(arguments?['date']);
    facility = arguments?['facility'] ?? 'No facility provided';

    // Fetch slots for the selected facility and date
    controller.fetchSlots(facility, arguments?['date']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Bookings")),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Facility: $facility", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Date: $date", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),

                // Observe and display slots dynamically
                Expanded(
                  child: Obx(() {
                    if (controller.bookings.isEmpty && !controller.loading.value) {
                      return Center(child: Text("No slots booked for this date.", style: TextStyle(fontSize: 18)));
                    }

                    return ListView.builder(
                      itemCount: controller.bookings.length,
                      itemBuilder: (context, index) {
                        var slot = controller.bookings[index];
                        var bookedBy = slot['bookedBy'] ?? {};

                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text("Time: ${slot['time']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Booked By: ${bookedBy['name'] ?? 'Unknown'}", style: TextStyle(fontSize: 16)),
                                Text("Email: ${bookedBy['email'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                                Text("Dept: ${bookedBy['department'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            leading: Icon(Icons.schedule, color: Colors.blue),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          // Loading Indicator with Reduced Opacity
          Obx(() {
            if (controller.loading.value) {
              return Container(
                color: Colors.black.withOpacity(0.3), // Background with less opacity
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
