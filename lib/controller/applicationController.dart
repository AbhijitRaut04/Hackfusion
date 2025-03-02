import 'dart:convert';
import 'dart:io';
import 'package:campus_cloud/routes/RouteNames.dart';
import 'package:path/path.dart' as path;
import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApplicationController extends GetxController{

  final box = GetStorage();
  RxBool loading =false.obs;

  Future<void> sendApplication(
      String subject,
      String body,
      List<String> to,
      String priority,
      File? image
      ) async {
    loading.value=true;
    final String? token = box.read("authToken");

    if (subject.isEmpty || body.isEmpty || to.isEmpty || token == null) {
      showSnackBar("Required", "Subject,body and To are required");
      loading.value=false;
      return;
    }

    String? imageUrl;

    // Upload the file if present
    if (image != null && await image.exists()) {
      imageUrl = await uploadImage(image);
      if (imageUrl == null) {
        showSnackBar("Error", "Image upload failed.");
        loading.value = false;
        return;
      }
    }

    final Uri url = Uri.parse("${dotenv.env["BACKEND_URL"]}/applications/");
    final Map<String, dynamic> data = {
      "title": subject,
      "body": body,
      "to": to,
      "priority": priority,
      if (imageUrl != null) "file": imageUrl, // Add file URL if available
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(RouteNames.Home);
        showSnackBar("Success", "Application sent successfully");
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        showSnackBar("Error", responseBody["message"]);
      }
    } catch (e) {
      showSnackBar("Error", e.toString());
      print("❌ Error: $e");
    }
    finally{
      loading.value=false;
    }
  }

    Future<String?> uploadImage(File image) async {
      try {
        final Uri uploadUrl = Uri.parse("${dotenv.env["BACKEND_URL"]}/image-upload");

        var request = http.MultipartRequest("POST", uploadUrl);
        request.files.add(
          await http.MultipartFile.fromPath(
            "photo",
            image.path,
            filename: path.basename(image.path),
          ),
        );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print(response.statusCode);
        print(responseBody);

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          return jsonResponse["imageUrl"]; // Extract file URL
        } else {
          showSnackBar("Error", "Error while uplaoding photo");
          print("❌ Image Upload Failed: ${jsonDecode(responseBody)["message"]}");
          return null;
        }
      } catch (e) {
        showSnackBar("Error", "Error while uplaoding photo");
        print("❌ Image Upload Error: $e");
        return null;
      }

  }

}