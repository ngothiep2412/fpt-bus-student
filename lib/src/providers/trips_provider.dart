import 'dart:convert';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TripProviders extends GetConnect {
  Future<ResponseApi> getListTripToday(String token) async {
    String key = 'student-today';
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip/$key');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    // Handle the response from the API
    if (response.statusCode == 401) {
      Get.snackbar("Fail", "You are not logged into the system");
    }
    if (response.statusCode == 403) {
      Get.snackbar("Fail", "Access denied");
    }
    if (response.statusCode == 404) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    if (response.statusCode == 500) {
      Get.snackbar("Fail", "Internal server error");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get list user');
    }
  }

  Future<ResponseApi> getTripDetail(String jwtToken, String tripId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip/search/$tripId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get Trip Detail');
    }
  }
}
