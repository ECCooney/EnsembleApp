import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ensemble/pages/auth/login_page.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String firstName = "";

  String lastName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView( //creates scroll bar if screen overflows
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    const Text(
                        "Ensemble",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 10),
                    const Text("Create your account", style: TextStyle (fontSize:15, fontWeight: FontWeight.w400)),
                    Image.asset("assets/logo.png"),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith( //from widgets folder with added  behaviour
                          labelText: "First Name",
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Theme.of(context).primaryColor,
                          )),
                      onChanged: (val){
                        setState((){
                          firstName= val;
                        });
                      },
                      validator: (val){
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith( //from widgets folder with added  behaviour
                          labelText: "Last Name",
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Theme.of(context).primaryColor,
                          )),
                      onChanged: (val){
                        setState((){
                          lastName= val;
                        });
                      },
                      validator: (val){
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith( //from widgets folder with added  behaviour
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          )),
                      onChanged: (val){
                        setState((){
                          email= val;
                          print (email);
                        });
                      },
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
                        obscureText: true,
                        decoration: textInputDecoration.copyWith( //from widgets folder with added  behaviour
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
                        validator: (val){
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val){
                          setState((){
                            password= val;
                          });
                        }
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width:double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 16)
                        ),
                        onPressed: () {
                          register();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(//can create two text children in one text piece using Text.rich
                        TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Login Now",
                                  style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    nextScreen(context, const LoginPage());

                                  }
                              )
                            ]
                        )
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }

  register(){

  }
}
