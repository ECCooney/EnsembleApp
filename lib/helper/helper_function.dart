//functions to store users logged in start in SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  //keys
  static String userLoggedInKey = "LOGGEDINKET";
  static String userNameKey = "USERNAMEKKEY";
  static String userEmailKey = "USEREMAIKEY";
  //saving the data to Shared Preferences

  //getting the data from Shared Preferences

  // Future in Flutter refers to an object that represents a value that is not yet available but will be at some point in the future.
  // A Future can be used to represent an asynchronous operation that is being performed,
  // such as fetching data from a web API, reading from a file, or performing a computation
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey); // if key exists in Shared Preferences return turn
  }

}