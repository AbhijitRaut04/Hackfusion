import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/helper.dart';

class ElectionController extends GetxController{
  var candidates = <String, List<String>>{}.obs; // Map to store position and candidates
  var isLoading = false.obs; // To show loading state
  var imageFile = Rxn<File>(); // Observable file
  var isVerifying = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchElectionData(); // Fetch data when the controller initializes
  }


  Future<void> captureSelfie() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      uploadSelfie();
    }
  }


  Future<void> uploadSelfie() async {
    if (imageFile.value == null) {
      Get.snackbar("Error", "No image captured!");
      return;
    }

  }

  Future<void> vote(BuildContext context,int positionIndex, int candidateIndex) async {
    const String voterAddress = "0x3AAab8FC66014ABF3249953207137Cc0b2c773AA";
    final Uri url = Uri.parse("http://192.168.32.63:5005/vote");

    final Map<String, dynamic> voteData = {
      "positionId": positionIndex,
      "candidateId": candidateIndex,
      "voterAddress": voterAddress
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(voteData),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData["success"] == true) {
        showSnackBar("Success","Voted successfully!");

        // Pop all screens to go back to the main page
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        // Show error message from response body
        showSnackBar("Error",responseData["error"] ?? "Voting failed!");
      }
    } catch (error) {
      print("Error submitting vote: $error");
    }
  }




  Future<void> fetchElectionData() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse("http://192.168.32.63:5005/allResults"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          Map<String, List<String>> fetchedCandidates = {};
          for (var position in data["allPositionResults"]) {
            String title = position["positionTitle"];
            List<String> candidateNames = (position["candidates"] as List)
                .map<String>((c) => c["candidateName"].toString())
                .toList();


            fetchedCandidates[title] = candidateNames;
          }
          candidates.value = fetchedCandidates;
        }
      } else {
        print("⚠️ Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }



}