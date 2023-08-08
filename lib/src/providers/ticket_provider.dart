import 'dart:convert';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/ticket_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TicketProviders extends GetConnect {
  Future<ResponseApi> getTicketComming(String token) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/coming');
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

  Future<TicketModel> getMyTicketDetail(
      String jwtToken, String ticketId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/$ticketId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final responseApi = TicketModel.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get Ticket Detail');
    }
  }

  Future<ResponseApi> deleteTicket(String jwtToken, String ticketId) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/cancel/$ticketId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'ticketId ': ticketId,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to delete Ticket Detail');
    }
  }
}
