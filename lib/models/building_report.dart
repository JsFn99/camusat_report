import 'dart:io';

class BuildingReport {
  late String nomPlaque;                // NOM DE LA PLAQUE
  late String adresse;                  // Adresse
  late String coordonnees;              // Coordonnées de l'immeuble
  late File imageImmeuble;              // Image immeuble
  late File screenSituationGeographique;// Screen situation géographique
  late File schema;                     // Schema
  late File imagePBI;                   // Image PBI
  Map<String, File> imagesPBO = {};            // Images PBO
  late File imageTestDeSignal;          // Image test de signal
  late int splitere;                    // Splitere
  late String pbiLocation;              // PBI Location
}