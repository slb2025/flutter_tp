import 'package:flutter/foundation.dart';

class VehicleApiData {
  final int id;
  final String title;
  final bool completed;

  VehicleApiData({
    required this.id,
    required this.title,
    required this.completed,
  });

  // Constructeur Factory pour la désérialisation
  factory VehicleApiData.fromJson(Map<String, dynamic> json) {
    // La méthode fromJson crée un objet à partir du Map JSON
    return VehicleApiData(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}