import 'package:ensemble/core/common/sign_in_button.dart';
import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final isLoading = ref.watch(authControllerProvider);
    String email = "";
    String password = "";
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(Constants.initialLogoPath,height: 40,),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          backgroundColor: Pallete.orangeCustomColor,
        ),
        body: isLoading ? const Loader():
        SingleChildScrollView( //creates scroll bar if screen overflows
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    const Text(
                        "Share and Share Alike",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 30),
                    Image.asset(Constants.logoPath),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: 'Enter the email you registered with',
                        labelText: 'Email',
                      ),
                      //validate whether it's an acceoptable email
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                            ? null //return nothing if that value matchs the pattern
                            : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                        labelText: 'Password',
                      ),
                        validator: (val){
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width:double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.sageCustomColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16)
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text.rich(//can create two text children in one text piece using Text.rich
                        TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Register Here",
                                  style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                              )
                            ]
                        )
                    ),
              const SignInButton(),
                  ],
                )
            ),

          ),
        )
    );
  }
}
