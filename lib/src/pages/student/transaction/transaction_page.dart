import 'dart:convert';
import 'package:fbus_app/src/core/helpers/image_helper.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/transaction_model.dart';
import 'package:fbus_app/main.dart';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:fbus_app/src/widgets/skelton.dart';
import 'package:intl/intl.dart';
import 'package:fbus_app/src/pages/student/transaction/transaction_controller.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionModel> transactionList = [];
  final controller = ScrollController();

  int _limit = 3;

  int _page = 1;

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  // const TransactionPage({super.key});
  TransactionController con = Get.put(TransactionController());

  double screenHeight = 0;

  double screenWidth = 0;

  var backgroundColor = Color.fromARGB(255, 229, 228, 234);

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
        Uri uri = Uri.http(
            Environment.API_URL_OLD,
            'api/v1/payment/transaction',
            {'page': _page.toString(), 'limit': _limit.toString()});
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
              transactionList.addAll(responseApi
                  .map((item) => TransactionModel.fromJson(item))
                  .toList());
            });
          } else {
            setState(() {
              _hasNextPage = false;
              Fluttertoast.showToast(
                msg: 'You have fetched all of your transaction list.',
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
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/payment/transaction',
          {'page': _page.toString(), 'limit': _limit.toString()});

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
        transactionList =
            responseApi.map((item) => TransactionModel.fromJson(item)).toList();
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
    // ticketList =
    //     con.rawList.map((item) => ListTicketModel.fromJson(item)).toList();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleString: 'Transaction History',
        implementLeading: true,
        notification: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 1;
            _limit = 3;
            _hasNextPage = true;
          });
          await _firstLoad();
        },
        child: _isFirstLoadRunning
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 220,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 220,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 20,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : transactionList.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: Text(
                              "No Transasction",
                              style: TextStyle(
                                color: AppColor.busdetailColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 300,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      transactionList.length <= 2
                          ? Expanded(
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height,
                                ),
                                child: ListView.builder(
                                  // controller: _controller,
                                  itemCount: transactionList.length,
                                  itemBuilder: (context, index) {
                                    return item(index);
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: transactionList.length,
                                itemBuilder: (context, index) {
                                  return item(index);
                                },
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

  Widget item(int index) {
    const marginHorizontal = 20.0;
    return GestureDetector(
      onTap: () {
        // print('ID: ${ticketList[index].id}');
        // con.handleTicketSelection(ticketList[index].id, context);
      },
      child: Container(
        width: screenWidth,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.busdetailColor.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.only(
            top: 20,
            bottom: 10,
            left: marginHorizontal,
            right: marginHorizontal),
        child: Row(
          children: [
            Container(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 320,
              padding: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     offset: Offset(10, 0),
                //     blurRadius: 10.0,
                //     spreadRadius: 0.2,
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.text1Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        transactionList[index].description.length > 30
                            ? "${transactionList[index].description.substring(0, 30)}..."
                            : transactionList[index].description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Type: ",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.text1Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          transactionList[index].type == "PAYMENT"
                              ? Text(
                                  transactionList[index].type,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.redAccent),
                                )
                              : Text(
                                  transactionList[index].type,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.greenAccent),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Amount:",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.text1Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          transactionList[index].type == "PAYMENT"
                              ? Row(
                                  children: [
                                    Text(
                                      '- ${transactionList[index].amount.toString()}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.busdetailColor),
                                    ),
                                    ImageHelper.loadFromAsset(
                                        Helper.getAssetIconName(
                                            'ico_coin.png')),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      '+ ${transactionList[index].amount.toString()}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.busdetailColor),
                                    ),
                                    ImageHelper.loadFromAsset(
                                        Helper.getAssetIconName(
                                            'ico_coin.png')),
                                  ],
                                )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created at",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.text1Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format(transactionList[index].createdAt),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Time: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('HH:mm')
                                .format(transactionList[index].createdAt),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
