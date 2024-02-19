import 'package:ensemble/core/common/google_sign_in_button.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ensemble/core/common/custom_text_field.dart';
import 'package:ensemble/core/common/loader.dart';
import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/theme/pallete.dart';

class RegisterScreen extends ConsumerStatefulWidget {

  const RegisterScreen({super.key});

  @override
  ConsumerState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends ConsumerState<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void signUp() {
    ref.read(authControllerProvider.notifier).signUpWithEmail(
      //trim removes white space at end of anything typed in
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      context);
    }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final GlobalKey<FormState> _formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.initialLogoPath,height: 40,),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Pallete.orangeCustomColor,
      ),
     body: isLoading ? const Loader(): Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Sign Up",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            icon: const Icon(Icons.person),
            controller: nameController,
            hintText: 'Enter your name',
            validator: (val){
              if (val!.length < 6) {
                return "Name must be at least 6 characters";
              } else {
                return null;
              }
            },
          )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            icon: const Icon(Icons.email),
            controller: emailController,
            hintText: 'Enter your email',
            validator: (val) {
              return RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(val!)
                  ? null //return nothing if that value matchs the pattern
                  : "Please enter a valid email";
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            icon: const Icon(Icons.lock),
            controller: passwordController,
            hintText: 'Enter your password',
            validator: (val){
              if (val!.length < 6) {
                return "Password must be at least 6 characters";
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            signUp();
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            textStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.white),
            ),
            minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width / 2.5, 50),
            ),
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
    );
  }
}

