import 'dart:io';

class Schema{
  static  int nbrEtages = 1;
  static Map<int , String> b2bLocations = {};
  static Map<int, String> pboLocations = {};
  static String pbiLocation = "Facade";

  static void reset() {
    nbrEtages = 1;
    b2bLocations = {};
    pboLocations = {};
    pbiLocation = "Facade";
  }

  static bool isValid() {
    if (pboLocations.isEmpty &&
      b2bLocations.isEmpty) {
      return false;
    }
    return true;
  }
}