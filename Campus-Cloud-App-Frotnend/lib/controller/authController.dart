import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../routes/RouteNames.dart';
import '../utils/helper.dart';

class AuthController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var signupLoading = false.obs;
  var loginLoading = false.obs;
  var isExtracting = false.obs;
  var otpResponse = "".obs;
  // api/image-upload
  Rx<File?> idCardImage = Rx<File?>(null);
  var imageUrl="".obs;


  final box = GetStorage();

  Future<void> extractDetailsFromIdCard(String idUrl) async {
      // ML MODEL
  }

  // Function to upload ID Card
  Future<void> uploadIdCard() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      idCardImage.value = imageFile;
      isExtracting.value = true;
      // Upload image and get URL
      await uploadImage(imageFile);

      // Extract details using uploaded image URL
      if (imageUrl.value.isNotEmpty) {
        await extractDetailsFromIdCard(imageUrl.value);
      }
      isExtracting.value = false;
    }
  }

  // Function to upload image to server
  Future<void> uploadImage(File imageFile) async {
    var uri = Uri.parse("${dotenv.env['BACKEND_URL']}/image-upload");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo', // Field name in API
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200 && jsonResponse.containsKey("imageUrl")) {
        imageUrl.value = jsonResponse["imageUrl"];
        print("✅ Image uploaded: ${imageUrl.value}");
      } else {
        String errorMessage = jsonResponse.containsKey("message")
            ? jsonResponse["message"]
            : "Unknown error.";
        showSnackBar("Error", errorMessage);
      }
    } catch (e) {
      print("⚠️ Error uploading image: $e");
      showSnackBar("Error", "An error occurred while uploading the image.");
    }
  }

  Future<void> sendOtp(String email) async {
    final String apiUrl = "${dotenv.env['BACKEND_URL']}/send-otp";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"to": email}), // Send email as "to" field
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        otpResponse.value = jsonResponse["otp"] ?? "";
      } else {
        print("⚠️ Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }
  bool verifyOtp() {
    String otp = otpController.text.trim();
    print(otp);
    print(otpResponse);
    if (otp.isEmpty) {
      showSnackBar("OTP Required", "Please enter otp");
      return false;
    }
    else{
      if(otp != otpResponse.value){
        showSnackBar("Error", "Wrong otp entered");
      }
    }
    return otp == otpResponse.value;
    return true;
  }


// Signup
  Future<bool> signup() async {
    final uri = Uri.parse("${dotenv.env['BACKEND_URL']}/students");

    final Map<String, dynamic> body = {
      "registrationNo": regNoController.text.trim(),
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text,
      "department": branchController.text.trim(),
      "idPhoto": imageUrl.value,
      "dob": dobController.text.trim(),
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse.containsKey("token")) {
          await box.write("authToken", jsonResponse["token"]);
          print("✅ Token stored: ${box.read("authToken")}");
          if (jsonResponse.containsKey("student")) {
            await saveUserDetails(jsonResponse["student"]);
            print(jsonResponse["student"]);
            print("✅ Token stored: ${box.read("name")}");
            print("✅ Token stored: ${box.read("registrationNo")}");
          }
        showSnackBar("Success", "Registration Success");
        return true;
        }
        else {
          print(response.body);
          showSnackBar("Error", response.body);
          return false;
        }
      }else {
        print(response.body);
        final responseBody = jsonDecode(response.body);
        FocusManager.instance.primaryFocus?.unfocus();
        showSnackBar("Error", responseBody["message"] ?? "An unknown error occurred");

        return false;
      }
    } catch (e) {
      showSnackBar("Error", "Something went wrong while registering");
      return false;
    }
  }

  Future<void> login() async {
    loginLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse("${dotenv.env['BACKEND_URL']}/students/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Store the token
        if (data.containsKey("token")) {
          await box.write("authToken", data["token"]);
          print("✅ Token stored: ${data["token"]}");
          if (data.containsKey("student")) {
            saveUserDetails(data["student"]);
          }
          // Navigate to home after successful login
          Get.offAllNamed(RouteNames.Home);
        } else {
          print("⚠️ Token not found in response");
          showSnackBar("Error", "Invalid response from server");
        }

      } else {
        print("⚠️ Login failed: ${response.statusCode} - ${response.body}");
        showSnackBar("Error", "Invalid email or password");
      }
    } catch (e) {
      print("❌ Exception: $e");
      showSnackBar("Error", "Something went wrong");
    } finally {
      loginLoading.value = false;
    }
  }


  Future<void> saveUserDetails(Map<String, dynamic> loginResponse) async {
    print(loginResponse);
    await box.write("UserId", loginResponse['_id']);
    await box.write("name", loginResponse['name']);
    await box.write("idPhoto", loginResponse['idPhoto']);
    await box.write("email", loginResponse['email']);
    await box.write("dept", loginResponse['department']);
    await box.write("registrationNo", loginResponse['registrationNo']);

    if (loginResponse.containsKey('profilePhoto')) {
      await box.write("profilePhoto", loginResponse['profilePhoto']);
    }
    if (loginResponse.containsKey('bloodGroup')) {
      await box.write("bloodgroup", loginResponse['bloodGroup']);
    }
    if (loginResponse.containsKey('phone')) {
      await box.write("contactnumber", loginResponse['phone']);
    }
    if (loginResponse.containsKey('address')) {
      await box.write("address", loginResponse['address']);
    }
  }

  // Get user details
  Map<String, dynamic>? getUserDetails() {
    String? userJson = box.read('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }
  // Clear user details (Logout)
  void clearUserDetails() {
    box.remove('user');
  }
}