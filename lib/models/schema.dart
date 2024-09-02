import 'dart:io';

class Schema{
  static  int nbrEtages = 1;
  static Map<int , String> b2bLocations = {};
  static Map<int, String> pboLocations = {};
  static int pbiLocation = 0;
  static int cablePbo = -2;

  static void reset() {
    nbrEtages = 1;
    b2bLocations = {};
    pboLocations = {};
    pbiLocation = 0;
    cablePbo = -2;
  }

  static bool isValid() {
    if (pboLocations.isEmpty ||
        pbiLocation == -2 ||
        cablePbo == -2
    ) {
      return false;
    }
    return true;
  }

  static bool notEmpty() {
    if (pboLocations.isNotEmpty &&
        pbiLocation != -2 &&
        cablePbo != -2 &&
      b2bLocations.isNotEmpty) {
      return false;
    }
    return true;
  }
}