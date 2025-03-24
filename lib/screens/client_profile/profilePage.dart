// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/get_icons.dart';
import 'package:site720_client/screens/client_profile/daily_status.dart';
import 'package:site720_client/screens/client_profile/deduction_work_screen.dart';
import 'package:site720_client/screens/client_profile/drawings_screen.dart';
import 'package:site720_client/screens/client_profile/extra_works_screen.dart';
import 'package:site720_client/screens/client_profile/gallery_screen.dart';
import 'package:site720_client/screens/client_profile/overview_screen.dart';
import 'package:site720_client/screens/client_profile/package_screen.dart';
import 'package:site720_client/screens/client_profile/payment_list_screen.dart';
import 'package:site720_client/screens/client_profile/phase_video_screen.dart';
import 'package:site720_client/screens/client_profile/schedule_payment.dart';
import 'package:site720_client/screens/client_profile/stages.dart';
import 'package:site720_client/screens/siverCard.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import '../bottomNavigationBarScreen.dart';

class ProfilePage extends StatefulWidget {
  String token;
  ProfilePage(this.token);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  int galleryIndex = 0;
  int vedioIndex = 0;
  // ProfilePageModel? profilePage;
  GetIconsModel? iconsList;
  bool? result = true;
  bool? result1 = true;
  String? name;

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    name = await Common.getSharedPref("name");
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
    iconsList = await HttpService.getIcons(widget.token);
    setState(() {});
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
              body: iconsList != null
                  ? CardSliverAppBar(
                      action: Container(),
                      height: 350,
                      background: Image.network(
                        iconsList!.data.bannerImage,
                        fit: BoxFit.cover,
                      ),
                      title: Text(iconsList!.data.clientName.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      titleDescription: Text(
                          iconsList!.data.projectName.toString(),
                          style: TextStyle(
                              color: Color(0xFF717171), fontSize: 12)),
                      backButton: true,
                      backButtonColors: [Colors.white, Colors.black],
                      body: Container(
                        alignment: Alignment.topLeft,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  bottom: 25.0,
                                  top: 25.0),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1.05),
                                itemCount: iconsList!.data.icons.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (iconsList!
                                                .data.icons[index].iconId ==
                                            "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DailyStatus(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "2") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DrawerScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "3") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ExtraWorksScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "4") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GalleryScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "5") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PackageScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "6") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentListScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "7") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SchedulePayment(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "8") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "9") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StageScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "10") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DeductionWorkScreen(),
                                              ));
                                        } else if (iconsList!
                                                .data.icons[index].iconId ==
                                            "11") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OverviewScreen(),
                                              ));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 242, 174, 150),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(3.0, 4.0),
                                                  blurRadius: 3)
                                            ]),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .08,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .16,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6.0, top: 6.0),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: iconsList!
                                                      .data.icons[index].iconUrl
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets.all(25.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                iconsList!
                                                    .data.icons[index].iconName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
