import 'dart:convert';
import 'dart:io';
import 'package:campus_cloud/models/cheatingModel.dart';
import 'package:campus_cloud/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CheatingController extends GetxController{
  final TextEditingController textEditingController = TextEditingController(text: "");
  var content = "".obs;
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);

  // show view variables
  var showViewLoading = false.obs;

  // fetch comments variables
  var showReplyLoading = false.obs;

  RxList<CheatingModel> cheatings = RxList<CheatingModel>();

  @override
  void onInit() {
    super.onInit();
    getCheatings(); // Call function on init
  }

  Future<void> getCheatings() async {
    final box = GetStorage();
    final String? token = box.read("authToken"); // Retrieve token

    if (token == null) {
      print('Token not found');
      return;
    }

    final url = Uri.parse("${dotenv.env['BACKEND_URL']}/cheatings");

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          cheatings.value = [for (var item in responseData) CheatingModel.fromJson(item)];
      } else {
        }
      }
    } catch (e) {
      showSnackBar("Error", "Something went wrong");
      print('Request failed: $e');
    }
  }

// to reset add view variables state
  void resetState(){
    content.value="";
    image.value=null;
  }

  @override
  void onClose(){
    textEditingController.dispose();
    super.onClose();
  }
}