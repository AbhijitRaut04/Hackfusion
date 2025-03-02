import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_cloud/controller/complaintsController.dart';
import 'package:video_player/video_player.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  final ComplaintsController complaintsController = Get.put(ComplaintsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Dropdown for category selection
                  Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Select Category",
                      border: OutlineInputBorder(),
                    ),
                    value: complaintsController.selectedCategory.value.isEmpty
                        ? null
                        : complaintsController.selectedCategory.value,
                    onChanged: (value) {
                      complaintsController.selectedCategory.value = value!;
                      complaintsController.selectedRecipients.clear();
                      if (complaintsController.selectedCategory.value == "Academics") {
                        complaintsController.fetchDepartmentAndSetRecipients();
                      }
                    },
                    items: complaintsController.categoryRecipients.keys.map((category) {
                      return DropdownMenuItem(value: category, child: Text(category));
                    }).toList(),
                  )),
                  const SizedBox(height: 10),

                  // Recipient Selection
                  Obx(() {
                    if (complaintsController.selectedCategory.value.isNotEmpty) {
                      return ExpansionTile(
                        title: const Text("Select Recipients"),
                        children: complaintsController.categoryRecipients[
                        complaintsController.selectedCategory.value]
                            ?.map((recipient) {
                          return Obx(() => CheckboxListTile(
                            title: Text(recipient),
                            value: complaintsController.selectedRecipients.contains(recipient),
                            onChanged: (checked) {
                              if (checked!) {
                                complaintsController.selectedRecipients.add(recipient);
                              } else {
                                complaintsController.selectedRecipients.remove(recipient);
                              }
                            },
                          ));
                        }).toList() ??
                            [],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 10),

                  // Subject Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: complaintsController.subjectController,
                          decoration: const InputDecoration(
                            hintText: "Subject",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Attach Image Button
                      GestureDetector(
                        onTap: () => complaintsController.pickImage(),
                        child: const Icon(Icons.image, size: 30),
                      ),

                      const SizedBox(width: 10),

                      // Attach Video Button
                      GestureDetector(
                        onTap: () => complaintsController.pickVideo(),
                        child: const Icon(Icons.video_library, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Body Input
                  TextField(
                    controller: complaintsController.bodyController,
                    maxLength: 500,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: "Body",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Submit Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            complaintsController.submitComplaint();
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),

                  // Image Preview
                  Obx(() {
                    if (complaintsController.image.value != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                complaintsController.image.value!,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white38,
                                child: IconButton(
                                  onPressed: () {
                                    complaintsController.image.value = null;
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Video Preview
                  Obx(() {
                    if (complaintsController.video.value != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: complaintsController.videoController.value != null &&
                                  complaintsController.videoController.value!.value.isInitialized
                                  ? VideoPlayer(complaintsController.videoController.value!)
                                  : const Center(child: CircularProgressIndicator()),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white38,
                                child: IconButton(
                                  onPressed: () {
                                    complaintsController.video.value = null;
                                    complaintsController.videoController.value?.dispose();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),

          // 🔄 Loading Overlay
          Obx(() {
            return complaintsController.loading.value
                ? Container(
              color: Colors.black.withOpacity(0.3), // Transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
