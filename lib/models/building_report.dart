import 'dart:io';

class BuildingReport {
  late String nomPlaque;                // NOM DE LA PLAQUE
  late String adresse;                  // Adresse
  late String coordonnees;              // Coordonnées de l'immeuble
  File? imageImmeuble;              // Image immeuble
  File? screenSituationGeographique;// Screen situation géographique
  File? schema;                     // Schema
  File? imagePBI;                   // Image PBI
  late List<File> imagesPBO;            // Images PBO
  File? imageTestDeSignal;          // Image test de signal
  int? splitere;                    // Splitere
  String? pbiLocation;              // PBI Location
}