
class Schema{
  static  int nbrEtages = 1;
  static Map<int , String> b2bLocations = {};
  static List<int> pboLocations = [];
  static String pbiLocation = "Facade";
  static int nbrCablesPbo = 0;

  static void reset() {
    nbrEtages = 1;
    nbrCablesPbo = 0;
    b2bLocations = {};
    pboLocations = [];
    pbiLocation = "Facade";
  }
}