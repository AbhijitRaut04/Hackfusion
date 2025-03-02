import 'package:campus_cloud/controller/applicationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class WriteApplication extends StatefulWidget {
  const WriteApplication({super.key});

  @override
  State<WriteApplication> createState() => _WriteApplicationState();
}

class _WriteApplicationState extends State<WriteApplication> {
  String? selectedApplication;
  String? selectedCategory;
  DateTimeRange? selectedLeaveDates;
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  ApplicationController controller = Get.put(ApplicationController());
  File? attachment;
  String? name;
  final box = GetStorage();

  final List<String> applicationTypes = [
    "Request Leave",
    "Permission Letter",
    "General Request",
  ];

  final Map<String, List<String>> categories = {
    "General Request": ["IT Support", "Library Access", "Hostel Request"],
    "Permission Letter": ["Event Permission", "Lab Access", "Extended Stay"],
  };

  final Map<String, List<Map<String, String>>> recipients = {
    "IT Support": [
      {"name": "IT Admin", "email": "it.admin@example.com"},
      {"name": "Tech Support", "email": "tech.support@example.com"}
    ],
    "Library Access": [
      {"name": "Library Head", "email": "library.head@example.com"},
      {"name": "Assistant Librarian", "email": "assistant.librarian@example.com"}
    ],
    "Hostel Request": [
      {"name": "Hostel Warden", "email": "warden@example.com"},
      {"name": "Assistant Warden", "email": "assistant.warden@example.com"}
    ],
    "Event Permission": [
      {"name": "Cultural Coordinator", "email": "cultural@example.com"},
      {"name": "Dean of Students", "email": "dean.students@example.com"}
    ],
    "Lab Access": [
      {"name": "Lab Incharge", "email": "lab.incharge@example.com"},
      {"name": "HOD", "email": "hod@example.com"}
    ],
    "Extended Stay": [
      {"name": "Hostel Manager", "email": "hostel.manager@example.com"},
      {"name": "Security Head", "email": "security@example.com"}
    ],
  };

  List<String> selectedRecipients = [];

  void toggleRecipientSelection(Map<String, String> recipient) {
    setState(() {
      String email = recipient["email"]!; // Extract email

      if (selectedRecipients.contains(email)) {
        selectedRecipients.remove(email);
      } else {
        selectedRecipients.add(email);
      }
    });
  }


  void selectLeaveDates() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedLeaveDates = picked;
        generateTemplate();
      });
    }
  }
  final Map<String, String> departmentMapping = {
    "bcs": "cse",
    "bec": "ece",
    "bme": "mech",
    "bch": "chem",
    "bit": "it",
    "bee": "ee",
    "bin": "inst",
    "bce": "civil",
  };

  void processRequestLeave() {
    String email = box.read('email') ?? "";
    if (email.length >= 7) {
      String deptCode = email.substring(4, 7).toLowerCase();
      String? mappedDept = departmentMapping[deptCode];
      if (mappedDept != null) {
        name="HOD ${mappedDept.toUpperCase()}";
        selectedRecipients.add("hod.$mappedDept@sggs.ac.in");
      }
    }
  }

  void generateTemplate() {
    if (selectedApplication == "Request Leave") {
      String leaveTemplate = """Dear $name,  

I hope you are doing well. I am writing to formally request leave from  
${selectedLeaveDates != null ? DateFormat('dd MMM yyyy').format(selectedLeaveDates!.start) : '[Start Date]'}  
to  
${selectedLeaveDates != null ? DateFormat('dd MMM yyyy').format(selectedLeaveDates!.end) : '[End Date]'}  
due to [Reason].  

I assure you that I will catch up on any missed lectures and assignments. Kindly grant me leave for the mentioned period.  

Thank you for your time and consideration.  

Sincerely,  
${box.read('name')}  
${box.read('registrationNo')}  
""";
      bodyController.text = leaveTemplate;
      subjectController.text = "Application for leave";
    } else {
      bodyController.text = "";
      subjectController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Write Application")),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Select Application Type"),
                    items: applicationTypes
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = null;
                        selectedRecipients.clear();
                        selectedApplication = value;
                        if (selectedApplication == "Request Leave") {
                          processRequestLeave();
                          generateTemplate();
                        } else {
                          bodyController.text = "";
                          subjectController.text = "";
                          name = "";
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  if (selectedApplication == "Request Leave")
                    TextButton.icon(
                      onPressed: selectLeaveDates,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(selectedLeaveDates == null
                          ? "Select Leave Dates"
                          : "${DateFormat('dd MMM yyyy').format(selectedLeaveDates!.start)} - ${DateFormat('dd MMM yyyy').format(selectedLeaveDates!.end)}"),
                    ),

                  if (selectedApplication == "General Request" ||
                      selectedApplication == "Permission Letter")
                    DropdownButtonFormField<String>(
                      key: ValueKey(selectedCategory),
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Select Category"),
                      items: categories[selectedApplication]?.map((category) {
                        return DropdownMenuItem(value: category, child: Text(category));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          selectedRecipients.clear();
                        });
                      },
                    ),

                  if (selectedCategory != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipients[selectedCategory]!
                          .map((recipient) => CheckboxListTile(
                        title: Text(recipient['name']!),
                        subtitle: Text(recipient['email']!),
                        value: selectedRecipients.contains(recipient["email"]),
                        onChanged: (_) => toggleRecipientSelection(recipient),
                      ))
                          .toList(),
                    ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: "Subject",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bodyController,
                    maxLength: 500,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: "Body",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickAttachment,
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Attach File"),
                      ),
                      if (attachment != null) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.check_circle, color: Colors.green),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: removeAttachment,
                        ),
                      ]
                    ],
                  ),
                  if (attachment != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          attachment!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller.sendApplication(subjectController.text, bodyController.text, selectedRecipients, selectedApplication=="Request Leave" || selectedCategory == "General Request" ? "low" : "high", attachment);
                    }, // Add your submit function
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Loading Overlay
        if (controller.loading.value)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    ));
  }




  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  Future<void> pickAttachment() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        attachment = File(pickedFile.path); // Store actual image file
        print(attachment?.path);
      });
    }
  }

  void removeAttachment() {
    setState(() {
      attachment = null;
    });
  }
}
