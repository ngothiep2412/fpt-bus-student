import 'dart:convert';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/ticket_coming_model.dart';
import 'package:fbus_app/src/widgets/custom_no_ticket_coming.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/pages/student/home/home_controller.dart';
import 'package:fbus_app/src/theme/padding.dart';
import 'package:fbus_app/src/widgets/custom_trip_today_card.dart';
import 'package:fbus_app/src/widgets/custom_ticket_coming.dart';
import 'package:fbus_app/src/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController con = Get.put(HomeController());
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<TripModel> _tripListToday = [];
  // ListTicketModel? ticketComming;
  int _indexTripToday = 0;
  bool _isFirstLoadRunning = false;
  String? _noTicketComming;
  TicketComingModel? _ticketComming;

  // void _onMessageReceived(RemoteMessage message) async {
  //   PushNotification notification = PushNotification(
  //     title: message.notification?.title,
  //     body: message.notification?.body,
  //     dataTitle: message.data['title'],
  //     dataBody: message.data['body'],
  //     sentTime: message.sentTime.toString(),
  //   );
  //   print('NOTIFICAITON: ${notification.title}');

  //   String? jwtToken = await storage.read(key: 'jwtToken');
  //   Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification/create');
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $jwtToken',
  //   };

  //   final Map<String, dynamic> body = {
  //     "title": notification.title,
  //     "body": notification.body,
  //     "dataTitle": notification.dataTitle,
  //     "dataBody": notification.dataBody,
  //     "sentTime": notification.sentTime,
  //     "userId": con.user.value.id
  //   };

  //   final http.Response response = await http.post(
  //     uri,
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );
  //   print('response.statusCode Trip Today: ${response.statusCode}');
  //   // Handle the response from the API
  //   if (response.statusCode == 401) {
  //     Get.snackbar("Fail", "You are not logged into the system");
  //   }
  //   if (response.statusCode == 403) {
  //     Get.snackbar("Fail", "Access denied");
  //   }
  //   // if (response.statusCode == 404) {
  //   //   final data = json.decode(response.body);
  //   //   final responseApi = ResponseApi.fromJson(data);
  //   //   _noTripToday = responseApi.message;
  //   // }
  //   if (response.statusCode == 500) {
  //     Get.snackbar("Fail", "Internal server error");
  //   }
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print('Create notification successfully!');
  //   }
  // }

  _firstLoadTripToday() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    String key = 'student-today';
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip/$key');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final http.Response response = await http.get(
      uri,
      headers: headers,
    );
    print('response.statusCode Trip Today: ${response.statusCode}');
    // Handle the response from the API
    if (response.statusCode == 401) {
      Get.snackbar("Fail", "You are not logged into the system");
    }
    if (response.statusCode == 403) {
      Get.snackbar("Fail", "Access denied");
    }
    // if (response.statusCode == 404) {
    //   final data = json.decode(response.body);
    //   final responseApi = ResponseApi.fromJson(data);
    //   _noTripToday = responseApi.message;
    // }
    if (response.statusCode == 500) {
      Get.snackbar("Fail", "Internal server error");
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        List responseApi = ResponseApi.fromJson(data).data;
        _tripListToday = responseApi
            .map((item) => TripModel.fromJson(item))
            .where((trip) =>
                DateTime.parse(
                        "${DateTime.now().toString().split(' ')[0]} ${trip.departureTime}")
                    .isAfter(DateTime.now()) &&
                trip.status == 1)
            .toList();
        print('DateTimeNow : ${DateTime.now()}');
        if (_tripListToday.length > 4) {
          setState(() {
            _indexTripToday = 4;
          });
        } else {
          setState(() {
            _indexTripToday = _tripListToday.length;
          });
        }
      });
    }
  }

  _firstLoadTicketComing() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket/coming');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );

      print('response.statusCode Ticket Coming: ${response.statusCode}');

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
        _noTicketComming = responseApi.message ?? "No trip found";
      }
      if (response.statusCode == 500) {
        Get.snackbar("Fail", "Internal server error");
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final responseApi = ResponseApi.fromJson(data);
        if (responseApi.data['ticket']['status'] == 'BOOKING') {
          setState(() {
            _noTicketComming = null;
            _ticketComming = TicketComingModel.fromJson(responseApi.data ?? {});
          });
        } else {
          setState(() {
            _noTicketComming = responseApi.message ?? "No trip found";
            _ticketComming = null;
          });
        }
      }
    } catch (err) {
      print(err);
      print('Something went wrong');
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _firstLoadTicketComing();
    _firstLoadTripToday();
    // print('con.ticketComming ${con.ticketComming}');
    // if (con.ticketComming.value != "No trip found") {
    //   ticketComming = ListTicketModel.fromJson(con.ticketComming['ticket']);
    // }
    // if (con.tripListToday != "Trip not found") {
    //   tripListToday = con.tripListToday
    //       .map<TripModel>((item) => TripModel.fromJson(item))
    //       .toList();
    // }
    // FirebaseMessaging.onMessage.listen(_onMessageReceived);
    // FirebaseMessaging.onMessageOpenedApp.listen(_onMessageReceived);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // checkForInitialMessage();
  }

  // Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print("Handling a background message: ${message.messageId}");
  // }

  // checkForInitialMessage() async {
  //   await Firebase.initializeApp();
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   print('NOTIFICATION DATE: ${initialMessage?.sentTime}');
  //   if (initialMessage != null) {
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //       sentTime: initialMessage.sentTime.toString(),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _firstLoadTicketComing();
            await _firstLoadTripToday();
            setState(() {});
          },
          child: _isFirstLoadRunning
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Obx(
                  () => getBody(),
                ),
        ));
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      // padding: const EdgeInsets.only(bottom: spacer),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipPath(
                clipper: BottomClipper(),
                child: Container(
                    width: size.width,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: AppColor.busdetailColor,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: appPadding, right: appPadding),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50 + 20),

                    //heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/navigation/home/notifications');
                            },

                            // padding: const EdgeInsets.only(right: 10.0),
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                // Positioned(
                                //   top: 0,
                                //   left: 15,
                                //   child: Container(
                                //     width: 10,
                                //     height: 10,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Colors.red,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        CustomHeading(
                          title: 'Hi, ${con.user.value.fullname}!',
                          subTitle: 'Let\'s start booking.',
                          color: Color(0xFFFFFFFF),
                        ),
                      ],
                    ),
                    SizedBox(height: spacer),

                    //promotion card
                    _noTicketComming != null
                        ? CustomNoTicketComing()
                        : _ticketComming != null
                            ? CustomTicketComing(
                                routeName: _ticketComming!
                                    .ticket!.trip.route.routeName,
                                timeLeft: _ticketComming!.timeLeft,
                                departureDate: DateFormat('yyyy-MM-dd').format(
                                    _ticketComming!.ticket!.trip.departureDate),
                                ticketId: _ticketComming!.ticket!.id,
                              )
                            : SizedBox(height: spacer),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: appPadding, right: appPadding),
            child: CustomTitle(
              title: "Today's Trip",
              length: _tripListToday.length,
            ),
          ),
          SizedBox(height: smallSpacer),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              left: appPadding,
              right: appPadding - 10.0,
            ),
            child: _tripListToday.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: appPadding, right: appPadding, top: 20),
                    child: Container(
                      height: 300,
                      child: Text(
                        'No Trip Today',
                        style: TextStyle(
                          color: AppColor.busdetailColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                : Wrap(
                    children: List.generate(_indexTripToday, (index) {
                      var data = _tripListToday[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(right: 15.0, bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            con.getTripDetail(context, data.id);
                          },
                          child: CustomTripTodayCard(
                            departureTime: data.departureTime,
                            ticketQuantity: data.ticketQuantity.toString(),
                            departure: data.departure,
                            destination: data.destination,
                            price: '10',
                          ),
                        ),
                      );
                    }),
                  ),
          ),
          _tripListToday.isEmpty
              ? Container(
                  height: 300,
                )
              : Container(
                  height: 200,
                )
        ],
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width - size.width / 4, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomHeading extends StatelessWidget {
  const CustomHeading({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2, // giới hạn tiêu đề tối đa 2 dòng
              overflow: TextOverflow
                  .ellipsis, // hiển thị dấu "..." khi tiêu đề vượt quá số dòng giới hạn
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          subTitle,
          style: TextStyle(
            color: color,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
