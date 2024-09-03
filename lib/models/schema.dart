import 'dart:ffi';
import 'dart:io';

class Schema{
  static  int nbrEtages = 1;
  static Map<int , String> b2bLocations = {};
  static List<int> pboLocations = [];
  static String pbiLocation = "Facade";

  static void reset() {
    nbrEtages = 1;
    b2bLocations = {};
    pboLocations = [];
    pbiLocation = "Facade";
  }
}