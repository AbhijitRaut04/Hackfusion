import 'package:campus_cloud/controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/routeNames.dart';
import '../widgets/imageAvatar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final box = GetStorage();
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.language),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(RouteNames.Settings),
              icon: const Icon(Icons.sort))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 280,
                      child: Text(
                        box.read("name") ?? "Name of Student",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Text(box.read("dept") ?? "Computer Science and Engineering"),
                    Text(box.read("registrationNo") ?? "2022BCSXXX"),
                  ],
                ),
                Obx(() => ImageAvatar(
                  radius: 40,
                  file: controller.image.value,
                  url: box.read("profilePhoto"),
                )),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Get.toNamed(RouteNames.EditProfile),
                        child: const Text("Edit Profile"))),
                const SizedBox(width: 20),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          //Get.toNamed(RouteNames.IdProof);
                        },
                        child: const Text("ID Proof")))
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Optional Fields", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            _buildOptionalField("Blood Group", box.read("bloodgroup") ?? "Not Provided"),
            _buildOptionalField("Contact Number", box.read("contactnumber") ?? "Not Provided"),
            _buildOptionalField("Address", box.read("address") ?? "Not Provided"),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.grey)),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                onPressed: () => _showEditDialog(label, value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String label, String currentValue) {
    TextEditingController controller = TextEditingController(text: "");
    ProfileController profileController = Get.find<ProfileController>();
    String selectedBloodGroup = currentValue; // For dropdown selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $label"),
        content: label == "Blood Group"
            ? DropdownButtonFormField<String>(
          value: (selectedBloodGroup != "Not Provided") ? selectedBloodGroup : null,
          items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
              .map((group) => DropdownMenuItem(
            value: group,
            child: Text(group),
          ))
              .toList(),
          onChanged: (value) {
            selectedBloodGroup = value!;
            controller.text=selectedBloodGroup;
          },
          decoration: const InputDecoration(hintText: "Select Blood Group"),
        )
            : TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter $label"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if(label=="Blood Group"){profileController.updateBloodGroup(selectedBloodGroup);}
              else if (label=="Contact Number"){profileController.updatePhoneNumber(controller.text);}
              else if (label=="Address"){profileController.updateAddress(controller.text);}
              box.write(label.toLowerCase().replaceAll(" ", ""), controller.text);
              print(box.read('contactnumber'));
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}