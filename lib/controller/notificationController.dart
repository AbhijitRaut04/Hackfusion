import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/notificationModel.dart';
import '../utils/helper.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  var loading = false.obs;
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  final box = GetStorage();

  void fetchNotifications() async {
    try {
      loading.value = true;
      final String? token = box.read('authToken'); // Read Bearer token

      if (token == null || token.isEmpty) {
        showSnackBar("Error", "User not authenticated");
        loading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse("${dotenv.env['BACKEND_URL']}/notifications"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        if (responseData.isNotEmpty) {
          notifications.value = responseData
              .map((item) => NotificationModel.fromJson(item))
              .toList();
        }
      } else {
        showSnackBar("Error", "Failed to fetch notifications");
      }
    } catch (error) {
      showSnackBar("Error", "Something went wrong: $error");
    } finally {
      loading.value = false;
    }
  }
}
