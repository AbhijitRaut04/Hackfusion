
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';
import '../routes/RouteNames.dart';
import '../views/widgets/authInput.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final AuthController controller = Get.put(AuthController());


  //Submit Method
  void submit(){
    if(_form.currentState!.validate()){
      controller.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Image.asset("assets/images/logoTransparent.png",width: 150,height: 150,),
                  const SizedBox(height:20),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign in",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                          Text("Welcome Back"),
                        ],
                      )
                  ),
                  const SizedBox(height:20),
                  authInput(label: "Email",hinttext: "Enter your email",controller:controller.emailController,validatorCallback: sggsEmailValidator),
                  const SizedBox(height:20),
                  authInput(label: "Password",hinttext: "Enter your password",isPassword: true,controller: controller.passwordController, validatorCallback: (String? arg) {
                    return null;
                    },),
                  const SizedBox(height:20),
                  ElevatedButton(
                    onPressed: (){
                      submit();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(40)),
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20,),
                  Text.rich(TextSpan(
                      children: [TextSpan(
                          text: " Sign up ",
                          style: const TextStyle(fontWeight:FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap=()=> Get.toNamed(RouteNames.Signup)

                      ),],
                      text: "Don't have an account ? "
                  ))
                ],
              ),
            ),
          ),
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
