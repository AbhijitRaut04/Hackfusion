import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controller/profileController.dart';
import '../../utils/helper.dart';
import '../widgets/imageAvatar.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController textEditingController =
  TextEditingController(text: "");
  final ProfileController controller = Get.find<ProfileController>();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Obx(
                      () => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ImageAvatar(
                        radius: 80,
                        file: controller.image.value,
                        url: box.read("profilePhoto"),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? token = box.read("authToken");
                          if (token == null) {
                            showSnackBar("Error", "User is not authenticated");
                            return;
                          }
                          await controller.handleImageUploadAndUpdate(context, token);
                        },
                        icon: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white38,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textEditingController,
                  maxLength: 55,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Add your description here.",
                    label: Text("Description"),
                  ),
                ),
              ],
            ),
          ),
        ),

        // **🔄 Loading Overlay**
        if (controller.loading.value)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ));
  }
}
