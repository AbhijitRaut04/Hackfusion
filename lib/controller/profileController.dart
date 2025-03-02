import 'dart:convert';
import 'dart:io';
import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  RxBool loading =false.obs;
  Rx<File?> image = Rx<File?>(null); // Reactive variable to store selected image
  String selectedBloodGroup = "";

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path); // Store selected file in Rx variable
    } else {
      showSnackBar("Image Selection", "No image selected");
    }
  }

  // Function to update avatar in /api/students/ (sending the file directly)
  Future<bool> updateAvatar(String token, File imageFile) async {
    String uploadUrl = "${dotenv.env['BACKEND_URL']}/image-upload";
    String updateProfileUrl = "${dotenv.env['BACKEND_URL']}/students/";

    try {
      loading.value=true;
      // Step 1: Upload Image and get URL
      var uploadRequest = http.MultipartRequest("POST", Uri.parse(uploadUrl));
      uploadRequest.files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

      var uploadResponse = await uploadRequest.send();
      var uploadResponseData = await uploadResponse.stream.bytesToString();
      print(uploadResponseData);
      if (uploadResponse.statusCode != 200) {
        showSnackBar("Error", "Failed to upload image");
        return false;
      }
      final uploadDecoded = jsonDecode(uploadResponseData);
      if (!uploadDecoded.containsKey("imageUrl")) {
        showSnackBar("Error", "Image upload failed, no URL received");
        return false;
      }
      String imageUrl = uploadDecoded["imageUrl"];
      // Step 2: Send URL to update profile photo
      var updateResponse = await http.put(
        Uri.parse(updateProfileUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"profilePhoto": imageUrl}),
      );
      var updateResponseData = jsonDecode(updateResponse.body);
      if (updateResponse.statusCode == 200) {
        final box = GetStorage();
        if (updateResponseData.containsKey("student") && updateResponseData["student"].containsKey("profilePhoto")) {
          String profilePhoto = updateResponseData["student"]["profilePhoto"];
          if (profilePhoto.isNotEmpty) {
            await box.write("profilePhoto", profilePhoto);
            print(box.read("profilePhoto"));
            showSnackBar("Success", "Avatar updated successfully!");
            return true;
          }
          else{
            showSnackBar("Error", "Failed to update avatar");
            return false;
          }
        }
      }
      showSnackBar("Error", "Failed to update avatar");
      return false;
    } catch (e) {
      print("Exception: $e");
      showSnackBar("Error", "Exception: $e");
      return false;
    }
    finally{
      loading.value=false;
    }
  }

  // Function to handle the entire process
  Future<void> handleImageUploadAndUpdate(BuildContext context, String token) async {
    await pickImageFromGallery(); // Pick image and store it in Rx variable
    if (image.value == null) {
      showSnackBar("Image Required", "Image not selected");
      return;
    }

    bool success = await updateAvatar(token, image.value!);
    if (!success) {
      showSnackBar("Error", "Error updating avatar");
    }
  }


  Future<bool> updateBloodGroup(String newBloodGroup) async {
    final box = GetStorage();
    String? token = box.read("authToken");

    if (token == null) {
      debugPrint("❌ Error: User not authenticated.");
      showSnackBar("Error", "Unauthenticated request please relogin");
      return false;
    }

    final String apiUrl = "${dotenv.env['BACKEND_URL']}/students/updatebloodgroup";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"bloodGroup": newBloodGroup}),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Blood group updated successfully.");
        showSnackBar("Success", "Blood group added successfully");
        return true;
      } else {
        debugPrint("❌ Error updating blood group: ${response.body}");
        showSnackBar("Error", "Something went wrong while adding blood group");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      showSnackBar("Error", "Something went wrong while adding blood group");
      return false;
    }
  }


  Future<bool> updatePhoneNumber(String phoneNumber) async {
    final box = GetStorage();
    String? token = box.read("authToken");

    if (token == null) {
      debugPrint("❌ Error: User not authenticated.");
      showSnackBar("Error", "Unauthenticated request please relogin");
      return false;
    }
    final String apiUrl = "${dotenv.env['BACKEND_URL']}/students/updatephone";
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Phone number updated successfully.");
        showSnackBar("Success", "Phone number added successfully");
        return true;
      } else {
        debugPrint("❌ Error updating Phone number: ${response.body}");
        showSnackBar("Error", "Something went wrong while adding Phone number");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      showSnackBar("Error", "Something went wrong while adding Phone number");
      return false;
    }
  }

  Future<bool> updateAddress(String address) async {
    final box = GetStorage();
    String? token = box.read("authToken");

    if (token == null) {
      debugPrint("❌ Error: User not authenticated.");
      showSnackBar("Error", "Unauthenticated request please relogin");
      return false;
    }
    final String apiUrl = "${dotenv.env['BACKEND_URL']}/students/updateaddress";
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"address": address}),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Address updated successfully.");
        showSnackBar("Success", "Address added successfully");
        return true;
      } else {
        debugPrint("❌ Error updating Address: ${response.body}");
        showSnackBar("Error", "Something went wrong while adding Address");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      showSnackBar("Error", "Something went wrong while adding Address");
      return false;
    }
  }


}
