import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vehicle/model/bookings.dart';
import 'package:vehicle/model/vehicle_type.dart';
import 'package:vehicle/model/vehicles.dart';

class ApiService {

  static const String baseUrl = 'https://octalogic-test-frontend.vercel.app/api/v1';

  // Fetch vehicle types
  Future<VehicleType> fetchVehicleTypes() async {
    final url = Uri.parse('$baseUrl/vehicleTypes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return VehicleType.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch vehicle types: ${response.body}');
    }
  }

  /// Fetch available vehicles by type
  Future<Vehicle> fetchVehicles(String vehicleId) async {
    final url = Uri.parse('$baseUrl/vehicles/$vehicleId');

    final response = await http.get(url);
    print("API Response: ${response.body}");


    if (response.statusCode == 200) {
      return Vehicle.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to fetch vehicles: ${response.body}');
    }
  }

  // booking data
  Future<Bookings> bookingData(String vehicleId) async {
    final url = Uri.parse('$baseUrl/bookings/$vehicleId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Bookings.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to fetch vehicles: ${response.body}');
    }
  }
}
