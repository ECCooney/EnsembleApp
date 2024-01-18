import 'package:ensemble/pages/auth/register_page.dart';
import 'package:ensemble/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
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
                      const Text("Login Now", style: TextStyle (fontSize:15, fontWeight: FontWeight.w400)),
                      Image.asset("assets/logo.png"),
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
                          child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16)
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(//can create two text children in one text piece using Text.rich
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Register Here",
                                style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  nextScreen(context, const RegisterPage());

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

  login(){
    //check the form is correct
    if(formKey.currentState!.validate()) {}

  }
}
