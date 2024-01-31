import 'package:ensemble/core/common/sign_in_button.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/custom_text_field.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/pallete.dart';

class RegisterScreen extends ConsumerStatefulWidget {

  const RegisterScreen({super.key});



  @override
  ConsumerState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends ConsumerState<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();



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
            controller: emailController,
            hintText: 'Enter your email',
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            controller: passwordController,
            hintText: 'Enter your password',
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: (){},
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
