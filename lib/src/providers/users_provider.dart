import 'dart:convert';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/response_api_pagination.dart';
import 'package:fbus_app/src/models/route_model.dart';
import 'package:fbus_app/src/models/ticket_booking_model.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UsersProviders extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  Future<ResponseApi> loginGoogle(String token) async {
    // String token = await user.getIdToken();
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/auth/sign-in');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'accessToken': token,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    // Handle the response from the API
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<ResponseApi> uploadPicture(
      UserModel user, String base64Image, String jwtToken) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/upload-file');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'type': 'profile',
      'imageBase64': "data:image/jpeg;base64,$base64Image",
      'userId': user.id,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<ResponseApi> updateProfileWithoutPicture(
      String name, String phone, String jwtToken, UserModel user) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/users/update/${user.id}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'fullname': name,
      'phone_number': phone,
    };

    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      Get.snackbar("Invalid", "You need enter with valid data");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<ResponseApi> updateProfilePicture(String imageUrl, String name,
      String phone, String jwtToken, UserModel user) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/v1/users/update/${user.id}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'fullname': name,
      'phone_number': phone,
      'profile_img': imageUrl,
    };

    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      Get.snackbar("Invalid", "You need enter with valid data");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<void> uploadNotification(
      String token, String title, String comment, String jwtToken) async {
    // Define the API endpoint
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification');

    // Create the request headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    // Create the request body
    Map<String, dynamic> body = {
      'token': token,
      'title': title,
      'content': comment,
    };

    // Send the POST request to the API endpoint
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    // Check the response status code
    if (response.statusCode == 200) {
      print('Notification uploaded successfully');
    } else {
      throw Error();
    }
  }

  Future<List<TripModel>> getDataTrip(
      String jwtToken, String date, String routeId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip',
        {'date': date, 'route_id': routeId});
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
    final http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode == 404) {
      Get.snackbar('Not found', "Trip not found");
      return [];
    }
    // Check the response status code
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data != null) {
        final trips = List<Map<String, dynamic>>.from(data);

        return trips.map((trip) => TripModel.fromJson(trip)).toList();
      }

      return [];
    } else {
      throw Exception(
          'Error fetching routes. Status code: ${response.statusCode}');
    }
  }

  Future<ResponseApi> getMyTicketDetail(
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
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to get Ticket Detail');
    }
  }

  Future<RouteModel> getRouteDetail(String jwtToken, String routeId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/route/$routeId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    // Check the response status code
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // Check if data is not null
      if (data != null) {
        final route = RouteModel.fromJson(data);
        return route;
      } else {
        throw Exception('Error fetching route detail. Response body is empty.');
      }
    } else {
      throw Exception(
          'Error fetching routes. Status code: ${response.statusCode}');
    }
  }

  Future<TicketBookingModel> getTicket(String jwtToken, String tripId) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/booking');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> body = {
      'tripId': tripId,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    // Check the response status code
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (json.decode(response.body)['status'] == "Fail") {
        Get.snackbar("Fail", json.decode(response.body)['message']);
        throw Exception('Error fetching route detail. Response body is empty.');
      } else {
        final data = json.decode(response.body)['data'];
        // Check if data is not null
        if (data != null) {
          final ticket = TicketBookingModel.fromJson(data[0]);
          return ticket;
        } else {
          throw Exception(
              'Error fetching route detail. Response body is empty.');
        }
      }
    } else if (response.statusCode == 400) {
      Get.snackbar("Fail", json.decode(response.body)['message']);
      throw Exception(
          'Error fetching routes. Status code: ${response.statusCode}');
    } else if (response.statusCode == 404) {
      Get.snackbar("Error", "Not Found Trip");
      throw Exception(
          'Error fetching routes. Status code: ${response.statusCode}');
    } else {
      Get.snackbar("Error", "Internal server error");
      throw Exception(
          'Error fetching routes. Status code: ${response.statusCode}');
    }
  }

  Future<void> subScribeToTopic(String id) async {
    await FirebaseMessaging.instance.subscribeToTopic(id);
  }

  // Future<List<ListTicketModel>> getListTicket(String jwtToken) async {
  //   Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket');
  //   print('Uri: $uri');
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $jwtToken',
  //   };

  //   final http.Response response = await http.get(
  //     uri,
  //     headers: headers,
  //   );
  //   // Check the response status code
  //   print('DATA ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body)['data'];
  //     if (data != null) {
  //       final routes = List<Map<String, dynamic>>.from(data);
  //       return routes
  //           .map((ticket) => ListTicketModel.fromJson(ticket))
  //           .toList();
  //     }

  //     return [];
  //   } else {
  //     throw Exception(
  //         'Error fetching routes. Status code: ${response.statusCode}');
  //   }
  // }

  Future<ResponseApiPagination> getListTicket(String token) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    // Handle the response from the API
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApiPagination.fromJson(data);
      return responseApi;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<ResponseApi> getWallet(String token) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/user/wallet');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 404) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    // Handle the response from the API
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } else {
      Get.snackbar("Fail", "Failed to get wallet");
      throw Exception('Failed to get wallet');
    }
  }
}
