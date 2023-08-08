// import 'package:fbus_app/src/core/const/colors.dart';
// import 'package:fbus_app/src/pages/student/map/map_controller.dart';
// import 'package:fbus_app/src/widgets/app_bar_container.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   MapController con = Get.put(MapController());
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MapController>(
//         builder: (value) => Scaffold(
//               appBar: CustomAppBar(
//                 context: context,
//                 implementLeading: true,
//                 titleString: 'Track Bus',
//                 notification: false,
//               ),
//               // backgroundColor: Colors.grey[900],
//               body: Stack(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.44,
//                     child: _googleMaps(),
//                   ),
//                   SafeArea(
//                     child: Column(
//                       children: [
//                         _iconCenterMyLocation(),
//                         Spacer(),
//                         _cardOrderInfo(context),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ));
//   }

//   Widget _googleMaps() {
//     return GoogleMap(
//       initialCameraPosition: con.initialPosition,
//       mapType: MapType.normal,
//       onMapCreated: con.onMapCreate,
//       myLocationButtonEnabled: false,
//       myLocationEnabled: false,
//       markers: Set<Marker>.of(con.markers.values),
//       zoomControlsEnabled: true,
//     );
//   }

//   Widget _cardOrderInfo(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.35,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           color: AppColor.busdetailColor.withOpacity(0.8),
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(20),
//             topLeft: Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 4,
//                 blurRadius: 6,
//                 offset: Offset(0, 3))
//           ]),
//       child: Column(
//         children: [
//           _listTileAddress('Departure', 'FPT HCM', Icons.my_location),
//           _listTileAddress('Destination', 'Vin home', Icons.location_on),
//           Divider(color: Colors.white, endIndent: 30, indent: 30, thickness: 2),
//           _clientInfo(),
//         ],
//       ),
//     );
//   }

//   Widget _clientInfo() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 35),
//       child: Row(
//         children: [
//           _imageClient(),
//           SizedBox(width: 15),
//           Text(
//             'Ngo Xuan Thiep',
//             style: TextStyle(
//                 color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//             maxLines: 1,
//           ),
//           Spacer(),
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 color: Colors.white),
//             child: IconButton(
//               onPressed: () => con.callNumber(),
//               icon: Icon(Icons.phone, color: Colors.black),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _imageClient() {
//     return Container(
//       height: 50,
//       width: 50,
//       // padding: EdgeInsets.all(2),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: FadeInImage(
//           image: AssetImage('assets/images/no-image.png') as ImageProvider,
//           // image: con.order.client!.image != null
//           //     ? NetworkImage(con.order.client!.image!)
//           //     : AssetImage('assets/images/no-image.png') as ImageProvider,
//           fit: BoxFit.cover,
//           fadeInDuration: Duration(milliseconds: 50),
//           placeholder:
//               AssetImage('assets/images/no-image.png') as ImageProvider,
//         ),
//       ),
//     );
//   }

//   Widget _listTileAddress(String title, String subtitle, IconData iconData) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       child: ListTile(
//         title: Text(
//           title,
//           style: TextStyle(
//               color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//           ),
//         ),
//         trailing: Icon(
//           iconData,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _iconCenterMyLocation() {
//     return GestureDetector(
//       onTap: () => con.centerPosition(),
//       child: Container(
//         alignment: Alignment.centerRight,
//         margin: EdgeInsets.symmetric(horizontal: 5),
//         child: Card(
//           shape: CircleBorder(),
//           color: Colors.white,
//           elevation: 4,
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Icon(
//               Icons.location_searching,
//               color: Colors.grey[600],
//               size: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _iconMyLocation() {
//     return Container(
//       alignment: Alignment.center,
//       child: Image.asset('assets/icon/my_location_yellow.png'),
//       width: 65,
//       height: 65,
//     );
//   }
// }
