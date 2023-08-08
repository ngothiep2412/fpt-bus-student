// import 'dart:async';
// import 'package:fbus_app/src/environment/environment.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:geolocator/geolocator.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// class MapController extends GetxController {
//   Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': false
//   });

//   // Order order = Order.fromJson(Get.arguments['order'] ?? {});
//   // OrdersProvider ordersProvider = OrdersProvider();

//   CameraPosition initialPosition = CameraPosition(
//       target: LatLng(10.845353045105886, 106.81863832521351),
//       zoom: 14.5,
//       tilt: 10.0);

//   LatLng? addressLatLng;
//   var addressName = ''.obs;

//   Completer<GoogleMapController> mapController = Completer();
//   Position? position;

//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
//   BitmapDescriptor? deliveryMarker;
//   BitmapDescriptor? homeMarker;

//   StreamSubscription? positionSubscribe;

//   Set<Polyline> polylines = <Polyline>{}.obs;
//   List<LatLng> points = [];

//   double distanceBetween = 0.0;
//   bool isClose = false;

//   MapController() {
//     checkGPS();
//     // connectAndListen();
//   }

//   void connectAndListen() {
//     socket.connect();
//     socket.onConnect((data) {
//       print('ESTE DISPISITIVO SE CONECTO A SOCKET IO');
//     });
//   }

//   Future animateCameraPosition(double lat, double lng) async {
//     GoogleMapController controller = await mapController.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat, lng), zoom: 13, bearing: 0)));
//   }

//   void onMapCreate(GoogleMapController controller) {
//     mapController.complete(controller);
//   }

//   void centerPosition() {
//     if (position != null) {
//       print('position 123: $position');
//       animateCameraPosition(position!.latitude, position!.longitude);
//     }
//   }

//   Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
//     ImageConfiguration configuration = ImageConfiguration();
//     BitmapDescriptor descriptor =
//         await BitmapDescriptor.fromAssetImage(configuration, path);

//     return descriptor;
//   }

//   void addMarker(String markerId, double lat, double lng, String title,
//       String content, BitmapDescriptor iconMarker) {
//     MarkerId id = MarkerId(markerId);
//     Marker marker = Marker(
//         markerId: id,
//         icon: iconMarker,
//         position: LatLng(lat, lng),
//         infoWindow: InfoWindow(title: title, snippet: content));

//     markers[id] = marker;

//     update();
//   }

//   void checkGPS() async {
//     deliveryMarker = await createMarkerFromAssets('assets/images/bus.png');
//     homeMarker = await createMarkerFromAssets('assets/images/home.png');

//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

//     if (isLocationEnabled == true) {
//       updateLocation();
//     } else {
//       bool locationGPS = await location.Location().requestService();
//       if (locationGPS == true) {
//         updateLocation();
//       }
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   void updateLocation() async {
//     try {
//       await _determinePosition();
//       position = await Geolocator.getLastKnownPosition();
//       print('Position AAA:  $position');
//       animateCameraPosition(position!.latitude, position!.longitude);

//       addMarker('delivery', position!.latitude, position!.longitude,
//           'Departure', '', deliveryMarker!);

//       addMarker('home', 10.845405731121392, 106.81735086497397, 'Destination',
//           '', homeMarker!);
//     } catch (e) {
//       print('Error: ${e}');
//     }
//   }

//   void callNumber() async {
//     String number = '0905952717' ?? ''; //set the number here
//     await FlutterPhoneDirectCaller.callNumber(number);
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     // socket.disconnect();
//     positionSubscribe?.cancel();
//   }
// }
