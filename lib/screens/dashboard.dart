// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site720_client/model/homePageModel.dart';
import 'package:site720_client/screens/changePassword.dart';
import 'package:site720_client/screens/complaintList.dart';
import 'package:site720_client/screens/detailsPage.dart';
import 'package:site720_client/screens/listPage.dart';
import 'package:site720_client/screens/login.dart';
import 'package:site720_client/screens/client_profile/profilePage.dart';
import 'package:site720_client/screens/villaProjectListPage.dart';
import 'package:site720_client/screens/webViewPage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

import 'bottomNavigationBarScreen.dart';

class Dashboard extends StatefulWidget {
  String? token;

  Dashboard({this.token});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool? result = true;
  bool? result1 = true;

  HomePageModel? dashboardDetails;
  String? name;
  String? imgPlan;
  int _currentPage = 0;
  int _currentPage1 = 0;
  Timer? _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  getData() async {
    name = await Common.getSharedPref("name");
    imgPlan = await Common.getSharedPref("plan");
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
    dashboardDetails = await HttpService.dashboard();
    if (dashboardDetails != null) {
      setState(() {
        _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
          if (_currentPage < dashboardDetails!.data.banner.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              getData();
              return null;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              //drawer: DrawerScreen(token: widget.token, name:name),
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
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
              body: dashboardDetails != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                            ),
                            Container(
                              height: 250,
                              child: PageView.builder(
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: dashboardDetails!.data.banner.length,
                                itemBuilder:
                                    (BuildContext context, int itemIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        imageUrl: dashboardDetails!
                                            .data.banner[itemIndex].imageUrl
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Center(
                                            child: Image.asset(Assets.logo)),
                                        errorWidget: (_, __, ___) => Center(
                                            child: Icon(Icons.error,
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            widget.token != null
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Stack(children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              // colorFilter: new ColorFilter.mode(
                                              //     Colors.black.withOpacity(0.3),
                                              //     BlendMode.darken),
                                              image: AssetImage(
                                                  "assets/images/homes4slides-4.png"),
                                              fit: BoxFit.fill,
                                            )),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              padding: new EdgeInsets.only(
                                                  right: 10.0, left: 10.0),
                                              child: new Container(
                                                height: 85.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                // child: Column(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.center,
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.center,
                                                //   children: [
                                                //     Stack(
                                                //       children: <Widget>[
                                                //         // Stroked text as border.
                                                //         Text(
                                                //           'My Home',
                                                //           style: TextStyle(
                                                //             fontSize: 25,
                                                //             fontWeight:
                                                //                 FontWeight.bold,
                                                //             foreground: Paint()
                                                //               ..style =
                                                //                   PaintingStyle
                                                //                       .stroke
                                                //               ..strokeWidth = 2
                                                //               ..color =
                                                //                   Colors.black,
                                                //           ),
                                                //         ),
                                                //         // Solid text as fill.
                                                //         Text(
                                                //           'My Home',
                                                //           style: TextStyle(
                                                //               fontSize: 25,
                                                //               color:
                                                //                   Colors.white,
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .bold),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ],
                                                // ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              widget.token!)),
                                                );
                                              },
                                              child: Center(
                                                child: Container(
                                                  width: 100,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                      child: Text(
                                                    'View',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                : SizedBox(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListPage()),
                                );
                              },
                              child: Container(
                                height: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/homes4slides-1.png"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VillaProjectListPage(
                                              token: widget.token)),
                                );
                              },
                              child: Container(
                                height: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/homes4slides-2.png"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsPage()),
                                );
                              },
                              child: Container(
                                height: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/homes4slides-3.png"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            widget.token == null
                                ? Stack(children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/homes4slides-4.png"),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    Positioned(
                                      left: 20,
                                      bottom: 20,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                          );
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                              child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    )
                                  ])
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              drawer: SizedBox(
                width: 250,
                child: Drawer(
                  // column holds all the widgets in the drawer
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        // ListView contains a group of widgets that scroll inside the drawer
                        child: ListView(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(Assets.avathar1,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.contain),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            widget.token == null
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login()),
                                                      );
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Sign in',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'Sign in to your account',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF717171)),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Text(
                                                    name.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                    ],
                                  )),
                                  ListTile(
                                    dense: true,
                                    minLeadingWidth: 5,
                                    leading: Container(
                                        width: 20,
                                        child: Center(
                                          child: Image.asset(
                                              'assets/images/home.png',
                                              height: 120,
                                              fit: BoxFit.contain),
                                        )),
                                    title: Text(
                                      'Home',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard(
                                                  token: widget.token,
                                                )),
                                      ),
                                    },
                                  ),
                                  widget.token != null
                                      ? ListTile(
                                          dense: true,
                                          minLeadingWidth: 5,
                                          leading: Container(
                                              width: 20,
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/images/profile.png',
                                                    height: 120,
                                                    fit: BoxFit.contain),
                                              )),
                                          title: Text(
                                            'My Profile',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          onTap: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                          widget.token!)),
                                            ),
                                          },
                                        )
                                      : SizedBox(),
                                  widget.token != null
                                      ? ListTile(
                                          dense: true,
                                          minLeadingWidth: 5,
                                          leading: Container(
                                              width: 20,
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/images/changepwd.png',
                                                    height: 120,
                                                    fit: BoxFit.contain),
                                              )),
                                          title: Text(
                                            'Change Password',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          onTap: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangePassword(
                                                          widget.token!)),
                                            ),
                                          },
                                        )
                                      : SizedBox(),
                                  widget.token != null
                                      ? ListTile(
                                          dense: true,
                                          minLeadingWidth: 5,
                                          leading: Container(
                                              width: 20,
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/images/complaint.png',
                                                    height: 120,
                                                    fit: BoxFit.contain),
                                              )),
                                          title: Text(
                                            'Complaint',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          onTap: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ComplaintListPage(
                                                          widget.token!)),
                                            ),
                                          },
                                        )
                                      : SizedBox(),
                                  ListTile(
                                    dense: true,
                                    minLeadingWidth: 5,
                                    leading: Container(
                                        width: 20,
                                        child: Center(
                                          child: Image.asset(
                                              'assets/images/privacy.png',
                                              height: 120,
                                              fit: BoxFit.contain),
                                        )),
                                    title: Text(
                                      'Privacy Policy',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebViewPage(
                                                'Privacy T&C',
                                                'https://home4.login2.co.in/Privacy_policy')),
                                      ),
                                    },
                                  ),
                                  widget.token != null
                                      ? ListTile(
                                          dense: true,
                                          minLeadingWidth: 5,
                                          leading: Container(
                                              width: 20,
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/images/logout.png',
                                                    height: 120,
                                                    fit: BoxFit.contain),
                                              )),
                                          title: Text(
                                            'Logout',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          onTap: () => _dialogue(context),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // This container holds the align
                      Container(
                          // This align moves the children to the bottom
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              // This container holds all the children that will be aligned
                              // on the bottom and should not scroll with the above ListView
                              child: Container(
                                  child: Column(
                                children: <Widget>[
                                  Image.asset(Assets.logo2,
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.contain)
                                ],
                              ))))
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBarScreen(
                token: widget.token,
              ),
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

  void _dialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: Text('Are you sure to Logout?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    Common.saveSharedPref("Logout", "success");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Dashboard()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }
}
