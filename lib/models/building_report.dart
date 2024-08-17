import 'dart:io';

class BuildingReport {
  final String nomPlaque;                // NOM DE LA PLAQUE
  final String adresse;                  // Adresse
  final String coordonnees;              // Coordonnées de l'immeuble
  late final File? imageImmeuble;              // Image immeuble
  final File? screenSituationGeographique;// Screen situation géographique
  final File? schema;                     // Schema
  final File? imagePBI;                   // Image PBI
  final List<File?> imagesPBO;            // Images PBO
  final File? imageTestDeSignal;          // Image test de signal
  late final int? splitere;                    // Splitere

  BuildingReport({
    required this.nomPlaque,
    required this.adresse,
    required this.coordonnees,
    required this.imageImmeuble,
    required this.screenSituationGeographique,
    required this.schema,
    required this.imagePBI,
    required this.imagesPBO,
    required this.imageTestDeSignal,
    required this.splitere,
  });

}
