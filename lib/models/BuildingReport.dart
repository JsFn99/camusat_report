import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class BuildingReport {
  static String nomPlaque = "";                // NOM DE LA PLAQUE
  static String adresse = "";                  // Adresse
  static String coordonnees = "";              // Coordonnées de l'immeuble
  static File? imageImmeuble;              // Image immeuble
  static File? screenSituationGeographique;// Screen situation géographique
  static pw.Widget? schema;                     // Schema
  static File? imagePBI;                   // Image PBI
  static Map<String, File> imagesPBO = {};            // Images PBO
  static File? imageTestDeSignal;          // Image test de signal
  static int splitere = -1;                    // Splitere
  static String pbiLocation = "Sous-Sol";              // PBI Location

  static void reset() {
    nomPlaque = "";                // NOM DE LA PLAQUE
    adresse = "";                  // Adresse
    imageImmeuble = null;              // Image immeuble
    screenSituationGeographique = null;// Screen situation géographique
    schema = null;                     // Schema
    imagePBI = null;                   // Image PBI
    imagesPBO = {};            // Images PBO
    imageTestDeSignal = null;          // Image test de signal
    splitere = -1;                    // Splitere
    pbiLocation = "Sous-Sol";              // PBI Location
  }

  static bool areImagesLoaded() {
    if (imageImmeuble == null || !imageImmeuble!.existsSync() ||
    imagePBI == null || !imagePBI!.existsSync() ||
    imageTestDeSignal == null || !imageTestDeSignal!.existsSync()) {
      return false;
    }
    return true;
  }
}