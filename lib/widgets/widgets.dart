import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black), //if border is clicked
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2)
    ),
    enabledBorder: OutlineInputBorder( //if border is not clicked
        borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)
    ),
);

//method for changing screens
//https://docs.flutter.dev/cookbook/navigation/navigation-basics#:~:text=To%20switch%20to%20a%20new,using%20a%20platform%2Dspecific%20animation.
void nextScreen(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page)); //push adds a Route to the stack of routes managed by the Navigator
}

void nextScreenReplace(context, page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            message,
            style: const TextStyle (fontSize: 14),),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: "OK", onPressed: (){}, textColor: Colors.white,
        )
    ));
}