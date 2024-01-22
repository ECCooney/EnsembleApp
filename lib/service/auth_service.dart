import 'package:ensemble/helper/helper_function.dart';
import 'package:ensemble/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  Future loginWithUserNameandPassword (String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .user!;
      if (user != null){
        //call database to update user data
        return true;
      }
    }
    on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

//register
Future registerUserWithEmailandPassword (String fullName, String email, String password) async {
  try {
    User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
        .user!;
    if (user != null){
      //call database to update user data
      await DatabaseService(uid: user.uid).saveUserData(fullName, email);
      return true;
    }


  }
  on FirebaseAuthException catch(e) {
    return e.message;
  }
}
//signout

Future signout() async{
  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserNameSF("");
    await firebaseAuth.signOut();
  }
  catch(e){
    return null;
  }
}
}