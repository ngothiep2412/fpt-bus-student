import 'dart:convert';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/notification_model.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/pages/student/notifications/notification_badge.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:fbus_app/src/widgets/skelton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationModel> _notifications = [];
  late int _totalNotifications = 0;
  final storage = FlutterSecureStorage();
  final controller = ScrollController();

  int _limit = 8;

  int _page = 1;

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        String? jwtToken = await storage.read(key: 'jwtToken');
        Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification/all',
            {'limit': _limit.toString(), 'page': _page.toString()});
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
          List responseApi = ResponseApi.fromJson(data).data;
          if (responseApi.isNotEmpty) {
            setState(() {
              _notifications.addAll(responseApi
                  .map((item) => NotificationModel.fromJson(item))
                  .toList());
            });
          } else {
            setState(() {
              _hasNextPage = false;
              Fluttertoast.showToast(
                msg: 'You have fetched all of your notification list.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.busdetailColor,
                textColor: Colors.white,
              );
            });
          }
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification/all',
          {'limit': _limit.toString(), 'page': _page.toString()});

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );
      // Handle the response from the API
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List responseApi = ResponseApi.fromJson(data).data;
        _notifications = responseApi
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  _getAllNotification() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/notification/all');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );
      // Handle the response from the API
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List responseApi = ResponseApi.fromJson(data).data;
        setState(() {
          _totalNotifications = responseApi.length;
        });
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _getAllNotification();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleString: 'Notifications',
        implementLeading: true,
        notification: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _limit = 8;
            _page = 1;
          });
          await _firstLoad();
          await _getAllNotification();
        },
        child: _isFirstLoadRunning
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, right: 30),
                        child: Row(
                          children: [
                            Skelton(
                              height: 20,
                              width: 170,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 80,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 80,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 80,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 80,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 80,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, top: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: NotificationBadge(
                          totalNotifications: _totalNotifications),
                    ),
                  ),
                  Expanded(
                    child: _notifications.isNotEmpty
                        ? ListView.builder(
                            controller: _controller,
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.busdetailColor,
                                      ),
                                      child: Icon(
                                        Ionicons.notifications,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      _notifications[index].title,
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          _notifications[index].body,
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(
                                              DateTime.parse(
                                                  _notifications[index]
                                                      .sentTime
                                                      .toString())),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(
                                color: AppColor.busdetailColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
