import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FacilityBookingController extends GetxController{
  RxBool loading =false.obs;
  List<dynamic> bookings = [];

  Future<void> fetchSlots(String facilityName, DateTime date) async {
    try {
      loading.value=true;
      final url = Uri.parse("${dotenv.env['BACKEND_URL']}/facility/");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "facilityName": facilityName,
          "date": date.toIso8601String().split('T')[0], // Format date
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bookings = (data['bookings']);
      }
    }catch (e) {
      print(e);
    }
    finally{
      loading.value=false;
    }
  }
}