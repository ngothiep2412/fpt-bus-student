// import 'dart:convert';

// import 'package:fbus_app/src/core/const/colors.dart';
// import 'package:fbus_app/src/core/helpers/image_helper.dart';
// import 'package:fbus_app/src/models/direction_model.dart';
// import 'package:fbus_app/src/models/station_model.dart';
// import 'package:fbus_app/src/pages/student/tripDetail/trip_detail_controller.dart';
// import 'package:fbus_app/src/utils/helper.dart';
// import 'package:fbus_app/src/widgets/app_bar_container.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:http/http.dart' as http;

// class MyTripDetailPage extends StatefulWidget {
//   @override
//   State<MyTripDetailPage> createState() => _MyTripDetailPageState();
// }

// class _MyTripDetailPageState extends State<MyTripDetailPage> {
//   TripDetailController con = Get.put(TripDetailController());

//   List<Station> stationList = [];
//   // final List<Station> listStation = con.tripDetail.
//   GoogleMapController? _googleMapController;
//   static const _initialCameraPosition = CameraPosition(
//     target: LatLng(10.841327801915343, 106.80989372591378),
//     zoom: 11.5,
//   );
//   Directions? _info;
//   late Marker _origin = Marker(
//     markerId: MarkerId('FPT HCM'),
//     position: LatLng(10.841327801915343, 106.80989372591378),
//     infoWindow: InfoWindow(
//       title: 'FPT',
//       snippet: 'address',
//     ),
//     icon: BitmapDescriptor.defaultMarker,
//   );

//   late Marker _destination = Marker(
//     markerId: MarkerId('ĐH GTVT'),
//     position: LatLng(10.845831460984828, 106.79441196919771),
//     infoWindow: InfoWindow(
//       title: 'ĐH GTVT',
//       snippet: 'address',
//     ),
//     icon: BitmapDescriptor.defaultMarker,
//   );

//   final Set<Polyline> _polyline = {};
//   List<LatLng> latlng = const [
//     LatLng(10.840919660389796, 106.80951580857409),
//     LatLng(10.839230325598086, 106.81181329385713),
//     LatLng(10.842950219081235, 106.81516116449302),
//     LatLng(10.848928522404082, 106.80873595822212),
//     LatLng(10.846238300698467, 106.79402561754924),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   Future<void> initialize() async {
//     final markerIcon = await getMarkerIcon('assets/images/buslocation.png');
//     stationList = con.routeDetail.stations;

//     setState(() {
//       _origin = Marker(
//         markerId: MarkerId(con.routeDetail.departure),
//         position: LatLng(
//             double.parse(con.routeDetail.departureCoordinates[0].latitude),
//             double.parse(con.routeDetail.departureCoordinates[0].longitude)),
//         infoWindow: InfoWindow(
//           title: con.routeDetail.departure,
//         ),
//         icon: markerIcon,
//       );

//       _destination = Marker(
//         markerId: MarkerId(con.routeDetail.destination),
//         position: LatLng(
//             double.parse(con.routeDetail.destinationCoordinates[0].latitude),
//             double.parse(con.routeDetail.destinationCoordinates[0].longitude)),
//         infoWindow: InfoWindow(
//           title: con.routeDetail.destination,
//         ),
//         icon: markerIcon,
//       );

//       _polyline.add(Polyline(
//           polylineId: PolylineId('polyline'),
//           visible: true,
//           points: latlng,
//           width: 5,
//           color: AppColor.busdetailColor));
//     });
//   }

//   Future<BitmapDescriptor> getMarkerIcon(String path) async {
//     final image = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(
//         size: Size.square(10),
//       ),
//       path,
//     );
//     return image;
//   }

//   @override
//   void dispose() {
//     _googleMapController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         context: context,
//         titleString: 'Trip Detail',
//         notification: false,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 220,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Scaffold(
//               body: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GoogleMap(
//                       myLocationButtonEnabled: true,
//                       zoomControlsEnabled: true,
//                       initialCameraPosition: _initialCameraPosition,
//                       onMapCreated: (controller) =>
//                           _googleMapController = controller,
//                       markers: {_origin, _destination},
//                       polylines:
//                           // _polyline,
//                           {
//                         if (_info != null)
//                           Polyline(
//                             polylineId: const PolylineId('overview_polyline'),
//                             color: AppColor.busdetailColor,
//                             width: 5,
//                             points: _info!.polylinePoints
//                                 .map((e) => LatLng(e.latitude, e.longitude))
//                                 .toList(),
//                           ),
//                       },
//                     ),
//                   ),
//                   if (_info != null)
//                     Positioned(
//                       top: 20.0,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 6.0,
//                           horizontal: 12.0,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColor.busdetailColor,
//                           borderRadius: BorderRadius.circular(20.0),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.white,
//                               offset: Offset(0, 2),
//                               blurRadius: 6.0,
//                             )
//                           ],
//                         ),
//                         child: Text(
//                           '${_info!.totalDistance}, ${_info!.totalDuration}',
//                           style: const TextStyle(
//                             fontSize: 16.0,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               floatingActionButton: Container(
//                 margin: EdgeInsets.only(right: 50),
//                 child: FloatingActionButton(
//                   backgroundColor: AppColor.busdetailColor,
//                   foregroundColor: Colors.white,
//                   onPressed: () => _googleMapController!.animateCamera(
//                     CameraUpdate.newCameraPosition(_initialCameraPosition),
//                   ),
//                   child: const Icon(Icons.center_focus_strong),
//                 ),
//               ),
//             ), // replace this with your map widget
//           ),
//           SafeArea(
//             child: Container(
//               height: 200,
//               padding: EdgeInsets.all(4),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 20, top: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Text(
//                                     'Remaining Seat Count:',
//                                     style: TextStyle(
//                                       color: AppColor.text1Color,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         con.tripDetail.ticketQuantity
//                                             .toString(),
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           color: AppColor.busdetailColor,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(
//                             right: 20,
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               con.bookATrip(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColor.busdetailColor,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text(
//                               'Book',
//                               style: TextStyle(
//                                 fontSize: 14, // decrease font size
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 20, top: 10),
//                           child: Container(
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Information Date Trip:',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                     color: AppColor.text1Color,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 20, top: 10),
//                           child: Row(
//                             children: [
//                               ImageHelper.loadFromAsset(
//                                 Helper.getAssetIconName('ico_calendal.png'),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'Date:',
//                                       style: TextStyle(
//                                         color: AppColor.busdetailColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     WidgetSpan(
//                                         child: SizedBox(
//                                       width: 10,
//                                     )),
//                                     TextSpan(
//                                       text: DateFormat('yyyy-MM-dd')
//                                           .format(con.tripDetail.departureDate),
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColor.text1Color,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 20, top: 10),
//                           child: Row(
//                             children: [
//                               ImageHelper.loadFromAsset(
//                                 Helper.getAssetIconName('ico_time.png'),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'Time :',
//                                       style: TextStyle(
//                                         color: AppColor.busdetailColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     WidgetSpan(
//                                         child: SizedBox(
//                                       width: 10,
//                                     )),
//                                     TextSpan(
//                                       text: con.tripDetail.departureTime,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColor.text1Color,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 20, top: 10),
//                           child: Container(
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Information Route:',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                     color: AppColor.text1Color,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 ElevatedButton(
//                                     onPressed: () => getDirections(
//                                         origin: _origin.position,
//                                         destination: _destination.position),
//                                     style: ElevatedButton.styleFrom(
//                                       minimumSize: Size(5, 25),
//                                       backgroundColor: AppColor.busdetailColor,
//                                     ),
//                                     child: Icon(
//                                       Ionicons.map,
//                                       color: Colors.white,
//                                       size: 20,
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 20),
//                           child: Text(
//                             'Departure:',
//                             style: TextStyle(
//                               color: AppColor.busdetailColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(left: 30),
//                               child: Row(
//                                 children: [
//                                   ImageHelper.loadFromAsset(
//                                       Helper.getAssetIconName(
//                                           'ico_location.png')),
//                                   TextButton(
//                                     onPressed: () =>
//                                         _googleMapController!.animateCamera(
//                                       CameraUpdate.newCameraPosition(
//                                           CameraPosition(
//                                         target: LatLng(
//                                             double.parse(con
//                                                 .routeDetail
//                                                 .departureCoordinates[0]
//                                                 .latitude),
//                                             double.parse(con
//                                                 .routeDetail
//                                                 .departureCoordinates[0]
//                                                 .longitude)),
//                                         zoom: 14.5,
//                                         tilt: 10.0,
//                                       )),
//                                     ),
//                                     style: TextButton.styleFrom(
//                                       foregroundColor: AppColor.text1Color,
//                                       textStyle: const TextStyle(
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     child: Text(con.tripDetail.departure),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 20),
//                           child: Text(
//                             'Destination:',
//                             style: TextStyle(
//                               color: AppColor.busdetailColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 30),
//                           child: Row(
//                             children: [
//                               ImageHelper.loadFromAsset(
//                                   Helper.getAssetIconName('ico_location.png')),
//                               TextButton(
//                                 onPressed: () =>
//                                     _googleMapController!.animateCamera(
//                                   CameraUpdate.newCameraPosition(
//                                     CameraPosition(
//                                       target: LatLng(
//                                           double.parse(con
//                                               .routeDetail
//                                               .destinationCoordinates[0]
//                                               .latitude),
//                                           double.parse(con
//                                               .routeDetail
//                                               .destinationCoordinates[0]
//                                               .longitude)),
//                                       zoom: 14.5,
//                                       tilt: 10.0,
//                                     ),
//                                   ),
//                                 ),
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: AppColor.text1Color,
//                                   textStyle: const TextStyle(
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 child: Text(con.tripDetail.destination),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 20, top: 10),
//                       child: Text(
//                         'Information Station:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: AppColor.text1Color,
//                         ),
//                       ),
//                     ),
//                     stationList.isNotEmpty
//                         ? Expanded(
//                             child: ListView.builder(
//                               itemCount: stationList.length,
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               padding: EdgeInsets.only(right: 25),
//                               itemBuilder: (context, index) {
//                                 return Column(
//                                   children: [
//                                     Container(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 20),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                               index == 0
//                                                   ? Icons.location_on
//                                                   : Icons.arrow_right_alt,
//                                               color: AppColor.busdetailColor),
//                                           TextButton(
//                                             onPressed: () =>
//                                                 _googleMapController!
//                                                     .animateCamera(
//                                               CameraUpdate.newCameraPosition(
//                                                 CameraPosition(
//                                                   target: LatLng(
//                                                       double.parse(
//                                                           stationList[index]
//                                                               .latitude),
//                                                       double.parse(
//                                                           stationList[index]
//                                                               .longitude)),
//                                                   zoom: 14.5,
//                                                   tilt: 10.0,
//                                                 ),
//                                               ),
//                                             ),
//                                             style: TextButton.styleFrom(
//                                               foregroundColor:
//                                                   AppColor.text1Color,
//                                               textStyle: const TextStyle(
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             child: Text(
//                                                 stationList[index].stationName),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (index != stationList.length - 1)
//                                       Padding(
//                                         padding: EdgeInsets.only(left: 20),
//                                         child: Divider(
//                                           thickness: 1,
//                                           color: Colors.grey[400],
//                                         ),
//                                       ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           )
//                         : Container(
//                             margin: EdgeInsets.only(top: 20),
//                             child: Center(
//                               child: Text(
//                                 "No Station",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: AppColor.busdetailColor,
//                                 ),
//                               ),
//                             ),
//                           )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Directions> getDirections({
//     required LatLng origin,
//     required LatLng destination,
//   }) async {
//     const String baseUrl =
//         'https://maps.googleapis.com/maps/api/directions/json';
//     final response = await http.get(
//       Uri.parse('$baseUrl?'
//           'origin=${origin.latitude},${origin.longitude}&'
//           'destination=${destination.latitude},${destination.longitude}&'
//           'key=AIzaSyAI9kPkskayYti5ttrZL_UfBlL3OkMEbvs'),
//     );

//     if (response.statusCode == 200) {
//       final directions = Directions.fromMap(json.decode(response.body));
//       setState(() {
//         _info = directions;
//       });
//       return Directions.fromMap(json.decode(response.body));
//     }
//     return throw Exception('Failed to load directions');
//   }
// }
