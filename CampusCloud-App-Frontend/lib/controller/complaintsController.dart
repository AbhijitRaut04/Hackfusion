import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../models/cheatingModel.dart';
import '../models/complaintsModel.dart';
import '../utils/helper.dart';
import 'package:path/path.dart';

class ComplaintsController extends GetxController {
  RxList<ComplaintsModel> complaints = RxList<ComplaintsModel>();
  Rx<File?> image = Rx<File?>(null);
  Rx<File?> video = Rx<File?>(null);
  Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  var loading = false.obs;

  final ImagePicker picker = ImagePicker();

  final Map<String, List<String>> departmentTeachers = {
    "bcs": ["Dean Academics", "Prof Suwarna Bansode (HOD)", "Prof Manisha Mahindrekar", "Dr. Prof U.V. Kulkarni", "Prof R.K. Chavan", "Prof A.V. Nandedkar", "Prof J.M. Waghmare", "Prof P.G. Kolapwar"],
    "bec": ["Dean Academics", "HOD ECE", "Dr. M. V. Bhalerao","Dr. R.R. Manthalkar", "Dr. U.R. Kamble", "A.V. Nandedkar"],
    "bme": ["Dean Academics", "HOD MECH", "Teacher A", "Teacher B", "Teacher C"],
  };


  RxMap<String, List<String>> categoryRecipients = <String, List<String>>{
    "Academics": ["Dean Academics"],
    "Hostel": ["Hostel Rector", "Hostel Warden", "Maintenance"],
    "Canteen": ["Canteen Manager", "Finance Dept"],
    "Transport": ["Transport Manager"],
    "Scholarship": ["Finance Manager", "Desk 1 Officer", "Desk 2 Officer"]
  }.obs;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  RxString selectedCategory = "".obs;
  RxList<String> selectedRecipients = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartmentAndSetRecipients();
    getComplaints();
  }

  void fetchDepartmentAndSetRecipients() {
    String deptCode = getDepartmentCode();
    if (deptCode.isNotEmpty) {
      List<String> newRecipients = departmentTeachers[deptCode] ?? ["Dean Academics"];
      categoryRecipients["Academics"] = newRecipients;
      categoryRecipients.refresh();
    }
  }

  String getDepartmentCode() {
    final box = GetStorage();
    String? registrationNo = box.read("registrationNo");
    if (registrationNo != null && registrationNo.length >= 7) {
      return registrationNo.substring(4, 7).toLowerCase();
    }
    return "";
  }

  // Pick an image
  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
    }
  }

  // Pick a video
  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      video.value = File(pickedFile.path);
      videoController.value = VideoPlayerController.file(video.value!)
        ..initialize().then((_) {
          videoController.refresh(); // Ensure UI updates
          videoController.value!.play();
        }).catchError((error) {
          print("Error initializing video: $error");
        });
    }
  }

  // Check for NSFW content
  Future<bool> checkNSFW(File file) async {
    // ML Model
    return false;
  }

  // Submit Complaint
  Future<void> submitComplaint() async {
    loading.value = true;
    var box = GetStorage();
    String? token = box.read('authToken');
    List<String> attachmentUrls = [];

    // NSFW Check before uploading
    if (image.value != null) {
      // bool isNSFW = await checkNSFW(image.value!);
      // if (isNSFW) {
      //   ScaffoldMessenger.of(Get.context!).showSnackBar(
      //     const SnackBar(content: Text('NSFW content detected! Upload rejected.')),
      //   );
      //   loading.value = false;
      //   return;  // Stop further execution if NSFW content detected
      // }

      // Upload image
      var uploadRequest = http.MultipartRequest("POST", Uri.parse("${dotenv.env['BACKEND_URL']}/image-upload"));
      uploadRequest.files.add(await http.MultipartFile.fromPath('photo', image.value!.path));

      var uploadResponse = await uploadRequest.send();
      var uploadResponseData = await uploadResponse.stream.bytesToString();
      if (uploadResponse.statusCode != 200) {
        showSnackBar("Error", "Failed to upload image");
        loading.value = false;
        return;
      }

      final uploadDecoded = jsonDecode(uploadResponseData);
      if (!uploadDecoded.containsKey("imageUrl")) {
        showSnackBar("Error", "Image upload failed, no URL received");
        loading.value = false;
        return;
      }
      String imageUrl = uploadDecoded["imageUrl"];
      attachmentUrls.add(imageUrl);
    }

    if (video.value != null) {
      bool isNSFW = await checkNSFW(video.value!);
      if (isNSFW) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('NSFW content detected! Upload rejected.')),
        );
        loading.value = false;
        return;  // Stop further execution if NSFW content detected
      }

      // Upload video (similar logic as for image)
    }

    // Submit Complaint
    try {
      var request = http.post(
        Uri.parse("${dotenv.env['BACKEND_URL']}/complaints"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": subjectController.text,
          "description": bodyController.text,
          "student": "1234",
          "keepAnonymousCount": 0,
          "complaintTo": selectedRecipients,
          "attachments": attachmentUrls,
        }),
      );

      var response = await request;
      if (response.statusCode == 200) {
        print("✅ Complaint submitted successfully!");
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Complaint submitted successfully!')),
        );
      } else {
        print("❌ Failed to submit complaint: ${response.body}");
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: ${response.body}')),
        );
      }
    } catch (e) {
      print("⚠️ Error: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    loading.value = false;
  }

  Future<void> getComplaints() async {
    final box = GetStorage();
    final String? token = box.read("authToken"); // Retrieve token

    if (token == null) {
      print('Token not found');
      return;
    }

    final url = Uri.parse("${dotenv.env['BACKEND_URL']}/complaints");

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Response body: ${response.body}"); // Debugging step

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        // ✅ Check if responseData is a List
        if (responseData is List) {
          if (responseData.isNotEmpty) {
            complaints.value = responseData.map((item) => ComplaintsModel.fromJson(item)).toList();
          } else {
            //showSnackBar("No Complaints", "No complaints found.");
          }
        }
        // ✅ Handle case where response is a Map (error message or unexpected format)
        else if (responseData is Map<String, dynamic>) {
          showSnackBar("Error", responseData["message"] ?? "Unexpected response format.");
          print("Unexpected response: $responseData");
        }
        // ❌ Handle invalid data
        else {
          showSnackBar("Error", "Invalid response data type.");
        }
      }
      // ❌ Handle non-200 responses
      else {
        showSnackBar("Error", "Failed to fetch complaints: ${response.statusCode}");
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      showSnackBar("Error", "Something went wrong while fetching complaints.");
      print('Request failed: $e');
    }
  }





}



