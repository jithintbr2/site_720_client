import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/client_by_id.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  ClientByIdModel? profilePage;
  bool? result = true;
  String token = "";

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    token = await Common.getSharedPref("token");
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      setState(() {
        result = true;
      });
    } else {
      setState(() {
        result = false;
      });
    }
    profilePage = await HttpService.getClientByID(token);
    if (profilePage != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              getData();
              return null;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text("Overview"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.h4logo),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        // SizedBox(width: 5,),
                        // Text('HOMES4',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ],
              ),
              body: profilePage != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            profilePage!.data.description != ''
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            profilePage!.data.description
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(0xFF717171),
                                                fontSize: 14)),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    profilePage!.data.workStartDate.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF717171),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    profilePage!.data.workEndDate.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF717171),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: Colors.grey.shade400,
                                  value: double.parse(profilePage!
                                          .data.totalPercentage
                                          .toString()) /
                                      100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue.shade900),
                                  minHeight: 20,
                                ),
                                Positioned(
                                  left: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "${profilePage!.data.totalPercentage.toString()}%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: Text(
                                          profilePage!.data.textDetails
                                              .toString(),
                                          style: TextStyle(
                                              color: Color(0xFF717171),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar: BottomNavigationBarScreen(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.noNetwork),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'No Network Found !',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      getData();
                    },
                    child: Container(
                      width: 120,
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
