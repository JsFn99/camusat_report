import 'dart:io';

class Schema{
  int nbrEtages = 1;
  Map<int , String> b2bLocations = {};
  Map<int, String> pboLocations = {};
  int pbiLocation = -2;
  int cablePbo = -2;

  bool isValid() {
    if (pboLocations.isEmpty ||
        pbiLocation == -2 ||
        cablePbo == -2
    ) {
      return false;
    }
    return true;
  }
}