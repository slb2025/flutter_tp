import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/vehicle_api_data.dart';

class VehicleApiService {
  // Déclare une méthode asynchrone qui retourne un Future<VehicleApiData?>
  // Le point d'interrogation indique que l'objet peut être null en cas d'erreur
  Future<VehicleApiData?> fetchVehicleData(int vehicleId) async {

    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$vehicleId');
    try {
      final response = await http.get(url); // Appel asynchrone

      if (response.statusCode == 200) {
        // Désérialisation (conversion JSON en objet Dart)
        final decodedData = jsonDecode(response.body);
        final vehicleData = VehicleApiData.fromJson(decodedData);

        return vehicleData; // Retourne l'objet réussi
      } else {
        // Gérer les erreurs (ex: 404)
        print('Échec de l\'API dans VehicleApiService. Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Gérer les erreurs de réseau/parsing
      print('Erreur réseau ou parsing dans VehicleApiService: $e');
      return null;
    }
  }
}