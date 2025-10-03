import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/vehicle_api_data.dart';

class VehicleApiService {
  Future<VehicleApiData?> fetchVehicleData(int vehicleId) async {

    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/$vehicleId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final vehicleData = VehicleApiData.fromJson(decodedData);

        return vehicleData;
      } else {
        print('Échec de l\'API dans VehicleApiService. Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur réseau ou parsing dans VehicleApiService: $e');
      return null;
    }
  }
}