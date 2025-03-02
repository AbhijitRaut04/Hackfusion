import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';
import '../routes/RouteNames.dart';
import '../views/widgets/authInput.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    controller.nameController.dispose();
    controller.emailController.dispose();
    controller.dobController.dispose();
    controller.branchController.dispose();
    controller.regNoController.dispose();
    controller.passwordController.dispose();
    controller.passwordConfirmController.dispose();
    controller.otpController.dispose();
    super.dispose();
  }

  void showOtpPanel() {
    Get.dialog(
      AlertDialog(
        title: const Text("OTP Verification"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("An OTP has been sent to ${controller.emailController.text}"),
            const SizedBox(height: 10),
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              bool otpValid = controller.verifyOtp();
              if(otpValid){
                Get.back();
                bool isRegistered=await controller.signup();
                if(isRegistered)  Get.offAllNamed(RouteNames.Home);
              }

            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void proceed() {
    if (_form.currentState!.validate()) {
      controller.sendOtp(controller.emailController.text);
      showOtpPanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.asset("assets/images/logoTransparent.png", width: 150, height: 150),
                    const SizedBox(height: 20),

                    Obx(() => Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await controller.uploadIdCard();
                          },
                          child: Text(controller.idCardImage.value == null
                              ? "Upload ID Card"
                              : "Change ID Card"),
                        ),
                        if (controller.idCardImage.value != null) ...[
                          const SizedBox(height: 10),
                          Image.file(controller.idCardImage.value!,
                              width: 200, height: 120, fit: BoxFit.cover),
                        ],
                      ],
                    )),
                    const SizedBox(height: 20),

                    Obx(() {
                      if (controller.idCardImage.value == null) {
                        return const Text(
                          "Please upload an ID card to proceed.",
                          style: TextStyle(fontSize: 16),
                        );
                      }

                      return Form(
                        key: _form,
                        child: Column(
                          children: [
                            authInput(
                              label: "Name",
                              hinttext: "Enter your name",
                              controller: controller.nameController,
                              validatorCallback:
                              ValidationBuilder().required().minLength(3).maxLength(50).build(),
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Date of Birth",
                              hinttext: "DD-MM-YYYY",
                              controller: controller.dobController,
                              validatorCallback: ValidationBuilder().required().build(),
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Branch",
                              hinttext: "Enter your branch",
                              controller: controller.branchController,
                              validatorCallback: ValidationBuilder().required().build(),
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Registration Number",
                              hinttext: "Enter your registration number",
                              controller: controller.regNoController,
                              validatorCallback: ValidationBuilder().required().build(),
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Email",
                              hinttext: "Enter your SGGS email",
                              controller: controller.emailController,
                              validatorCallback: sggsEmailValidator,
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Password",
                              hinttext: "Enter your password",
                              isPassword: true,
                              controller: controller.passwordController,
                              validatorCallback:
                              ValidationBuilder().required().minLength(5).maxLength(20).build(),
                            ),
                            const SizedBox(height: 20),

                            authInput(
                              label: "Confirm Password",
                              hinttext: "Confirm your password",
                              isPassword: true,
                              controller: controller.passwordConfirmController,
                              validatorCallback: (arg) {
                                if (controller.passwordController.text != arg) {
                                  return "Confirm password does not match";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: proceed,
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(const Size.fromHeight(40)),
                              ),
                              child: const Text("Proceed"),
                            ),
                            const SizedBox(height: 20),


                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: " Sign in ",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.toNamed(RouteNames.Login),
                                  ),
                                ],
                                text: "Already have an account? ",
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Obx(() => controller.isExtracting.value
                ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  String? sggsEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@sggs\.ac\.in$').hasMatch(value)) {
      return "Enter a valid SGGS email (e.g., yourname@sggs.ac.in)";
    }
    return null;
  }
}