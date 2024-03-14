import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/material.dart';
class Borders {

  static OutlineInputBorder outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Pallete.orangeCustomColor, width: 1), // Set custom orange color for border
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Pallete.blackColor, width: 2), // Set custom black color for focused border
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Pallete.orangeCustomColor, width: 1), // Set custom orange color for border
  );
}
