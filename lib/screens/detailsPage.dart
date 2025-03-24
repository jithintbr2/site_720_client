import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/aboutUsModel.dart';
import 'package:site720_client/screens/fullImagePage.dart';
import 'package:site720_client/screens/siverCard.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'bottomNavigationBarScreen.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int selectedIndex = 0;
  int serviceIndex = 0;
  bool? result = true;
  bool? result1 = true;

  AboutUsModel? aboutUs;
  String? name;

  void initState() {
    // TODO: implement initState
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
    aboutUs = await HttpService.aboutUs();
    if (aboutUs != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: aboutUs != null
                ? CardSliverAppBar(
                    action: Container(),
                    height: 350,
                    background: Image.network(
                      aboutUs!.data!.mainImage.toString(),
                      fit: BoxFit.cover,
                    ),
                    title: Text(aboutUs!.data!.companyName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    titleDescription: Text(
                      aboutUs!.data!.shortDescription.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      maxLines: 2,
                    ),
                    card: NetworkImage(aboutUs!.data!.subImage.toString()),
                    backButton: true,
                    backButtonColors: [Colors.white, Colors.black],
                    body: Container(
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                                "Why go for " +
                                    aboutUs!.data!.companyName.toString() +
                                    "?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20, top: 18),
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 0),
                                        color: selectedIndex == 0
                                            ? Color(0xFFd5f5f4)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Overview',
                                            style: TextStyle(
                                              color: selectedIndex == 0
                                                  ? Color(0xFF3c9f9a)
                                                  : Color(0xFF717171),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 0),
                                        color: selectedIndex == 1
                                            ? Color(0xFFd5f5f4)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                              color: selectedIndex == 1
                                                  ? Color(0xFF3c9f9a)
                                                  : Color(0xFF717171),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 2;
                                    });
                                    print(selectedIndex);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 0),
                                        color: selectedIndex == 2
                                            ? Color(0xFFd5f5f4)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Service',
                                            style: TextStyle(
                                              color: selectedIndex == 2
                                                  ? Color(0xFF3c9f9a)
                                                  : Color(0xFF717171),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 3;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 0),
                                        color: selectedIndex == 3
                                            ? Color(0xFFd5f5f4)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Videos',
                                            style: TextStyle(
                                              color: selectedIndex == 3
                                                  ? Color(0xFF3c9f9a)
                                                  : Color(0xFF717171),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedIndex == 0)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF96b2b5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          aboutUs!.data!.overviewTitle
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        aboutUs!.data!.overviewDescription
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (selectedIndex == 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullImagePage(aboutUs!
                                                              .data!
                                                              .images![index]
                                                              .image
                                                              .toString())),
                                                );
                                              },
                                              child: Container(
                                                height: 220,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          aboutUs!
                                                              .data!
                                                              .images![index]
                                                              .image
                                                              .toString()),
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                            ),
                                          ),
                                      itemCount:
                                          aboutUs!.data!.images!.length)),
                            ),
                          if (selectedIndex == 2)
                            Column(
                              children: [
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 10, top: 18),
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < aboutUs!.data!.services!.length;
                                          i++)
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              serviceIndex = i;
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 0),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6))),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          aboutUs!
                                                              .data!
                                                              .services![i]
                                                              .service
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: serviceIndex ==
                                                                    i
                                                                ? Color(
                                                                    0xFF3c9f9a)
                                                                : Color(
                                                                    0xFF717171),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        serviceIndex == i
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Color(
                                                                      0xFF3c9f9a),
                                                                ),
                                                                height: 3,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .2,
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF96b2b5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              aboutUs!
                                                  .data!
                                                  .services![serviceIndex]
                                                  .service
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            aboutUs!
                                                .data!
                                                .services![serviceIndex]
                                                .serviceDescription
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          if (selectedIndex == 3)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final List<YoutubePlayerController>
                                            _controllers = [
                                          for (int i = 0;
                                              i < aboutUs!.data!.video!.length;
                                              i++)
                                            aboutUs!.data!.video![i],
                                        ]
                                                .map<YoutubePlayerController>(
                                                  (videoId) =>
                                                      YoutubePlayerController(
                                                    initialVideoId: videoId,
                                                    flags:
                                                        const YoutubePlayerFlags(
                                                      autoPlay: false,
                                                    ),
                                                  ),
                                                )
                                                .toList();
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: InkWell(
                                            onTap: () {},
                                            child: YoutubePlayer(
                                              key: ObjectKey(
                                                  _controllers[index]),
                                              controller: _controllers[index],
                                              actionsPadding:
                                                  const EdgeInsets.only(
                                                      left: 16.0),
                                              bottomActions: [
                                                CurrentPosition(),
                                                const SizedBox(width: 10.0),
                                                ProgressBar(isExpanded: true),
                                                const SizedBox(width: 10.0),
                                                RemainingDuration(),
                                                FullScreenButton(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: aboutUs!.data!.video!.length)),
                            ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Design ideas for your home",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "Find design style and inspiring ideas for your dream house",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xFF717171))),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
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
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: BottomNavigationBarScreen(),
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
                      //getData();
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

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: CustomScrollView(
  //       slivers: <Widget>[
  //         SliverAppBar(
  //           expandedHeight: 200.0,
  //           floating: false,
  //           pinned: true,
  //           flexibleSpace: FlexibleSpaceBar(
  //                               title: Text(aboutUs!.data!.companyName.toString(),
  //                                   style: TextStyle(
  //                                       color: Colors.black,
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold)),
  //             background: Image.network(
  //               aboutUs!.data!.mainImage.toString(),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         SliverList(
  //           delegate: SliverChildListDelegate([
  //             Container(
  //               alignment: Alignment.topLeft,
  //               color: Colors.white,
  //               width: MediaQuery.of(context).size.width,
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 50,
  //                   ),
  //                   Container(
  //                     alignment: Alignment.centerLeft,
  //                     margin: EdgeInsets.only(left: 20),
  //                     child: Text(
  //                         "Why go for " +
  //                             aboutUs!.data!.companyName.toString() +
  //                             "?",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 18)),
  //                   ),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     margin: EdgeInsets.only(left: 20, top: 18),
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 30,
  //                     child: ListView(
  //                       scrollDirection: Axis.horizontal,
  //                       children: <Widget>[
  //                         InkWell(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedIndex = 0;
  //                             });
  //                           },
  //                           child: Container(
  //                             width:
  //                             MediaQuery.of(context).size.width * .25,
  //                             height: 30,
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     color: Colors.white, width: 0),
  //                                 color: selectedIndex == 0
  //                                     ? Color(0xFFd5f5f4)
  //                                     : Colors.white,
  //                                 borderRadius: const BorderRadius.all(
  //                                     Radius.circular(6))),
  //                             child: Center(
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     'Overview',
  //                                     style: TextStyle(
  //                                       color: selectedIndex == 0
  //                                           ? Color(0xFF3c9f9a)
  //                                           : Color(0xFF717171),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedIndex = 1;
  //                             });
  //                           },
  //                           child: Container(
  //                             width:
  //                             MediaQuery.of(context).size.width * .25,
  //                             height: 35,
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     color: Colors.white, width: 0),
  //                                 color: selectedIndex == 1
  //                                     ? Color(0xFFd5f5f4)
  //                                     : Colors.white,
  //                                 borderRadius: const BorderRadius.all(
  //                                     Radius.circular(6))),
  //                             child: Center(
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     'Gallery',
  //                                     style: TextStyle(
  //                                       color: selectedIndex == 1
  //                                           ? Color(0xFF3c9f9a)
  //                                           : Color(0xFF717171),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedIndex = 2;
  //                             });
  //                             print(selectedIndex);
  //                           },
  //                           child: Container(
  //                             width:
  //                             MediaQuery.of(context).size.width * .25,
  //                             height: 35,
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     color: Colors.white, width: 0),
  //                                 color: selectedIndex == 2
  //                                     ? Color(0xFFd5f5f4)
  //                                     : Colors.white,
  //                                 borderRadius: const BorderRadius.all(
  //                                     Radius.circular(5))),
  //                             child: Center(
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     'Service',
  //                                     style: TextStyle(
  //                                       color: selectedIndex == 2
  //                                           ? Color(0xFF3c9f9a)
  //                                           : Color(0xFF717171),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedIndex = 3;
  //                             });
  //                           },
  //                           child: Container(
  //                             width:
  //                             MediaQuery.of(context).size.width * .25,
  //                             height: 35,
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     color: Colors.white, width: 0),
  //                                 color: selectedIndex == 3
  //                                     ? Color(0xFFd5f5f4)
  //                                     : Colors.white,
  //                                 borderRadius: const BorderRadius.all(
  //                                     Radius.circular(6))),
  //                             child: Center(
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     'Videos',
  //                                     style: TextStyle(
  //                                       color: selectedIndex == 3
  //                                           ? Color(0xFF3c9f9a)
  //                                           : Color(0xFF717171),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   if (selectedIndex == 0)
  //                     Padding(
  //                       padding: const EdgeInsets.all(20),
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(10),
  //                             color: Color(0xFF96b2b5)),
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(20),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment:
  //                             CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                   aboutUs!.data!.overviewTitle
  //                                       .toString(),
  //                                   style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 18)),
  //                               SizedBox(
  //                                 height: 10,
  //                               ),
  //                               Text(
  //                                 aboutUs!.data!.overviewDescription
  //                                     .toString(),
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.w400,
  //                                     fontSize: 15),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   if (selectedIndex == 1)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 20),
  //                       child: Container(
  //                           child: ListView.builder(
  //                               shrinkWrap: true,
  //                               physics: NeverScrollableScrollPhysics(),
  //                               itemBuilder: (context, index) => Padding(
  //                                 padding: const EdgeInsets.only(
  //                                   left: 20,
  //                                   right: 20,
  //                                   bottom: 20,),
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                           builder: (context) =>
  //                                               FullImagePage(aboutUs!
  //                                                   .data!
  //                                                   .images![index]
  //                                                   .image
  //                                                   .toString())),
  //                                     );
  //                                   },
  //                                   child: Container(
  //                                     height: 220,
  //                                     decoration: BoxDecoration(
  //                                         borderRadius:
  //                                         BorderRadius.circular(10),
  //                                         image: DecorationImage(
  //                                           image: NetworkImage(aboutUs!
  //                                               .data!
  //                                               .images![index]
  //                                               .image
  //                                               .toString()),
  //                                           fit: BoxFit.fill,
  //                                         )),
  //                                   ),
  //                                 ),
  //                               ),
  //                               itemCount: aboutUs!.data!.images!.length)),
  //                     ),
  //                   if (selectedIndex == 2)
  //                     Column(
  //                       children: [
  //                         SizedBox(height: 5),
  //                         Container(
  //                           alignment: Alignment.center,
  //                           margin: EdgeInsets.only(left: 10, top: 18),
  //                           width: MediaQuery.of(context).size.width,
  //                           height: 30,
  //                           child: ListView(
  //                             scrollDirection: Axis.horizontal,
  //                             children: <Widget>[
  //                               for (int i = 0;
  //                               i < aboutUs!.data!.services!.length;
  //                               i++)
  //                                 InkWell(
  //                                   onTap: () {
  //                                     setState(() {
  //                                       serviceIndex = i;
  //                                     });
  //                                   },
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(left:20 ),
  //                                     child: Container(
  //                                       height: 30,
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                               color: Colors.white,
  //                                               width: 0),
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                           const BorderRadius.all(
  //                                               Radius.circular(6))),
  //                                       child: Center(
  //                                         child: Row(
  //                                           mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                           children: [
  //                                             Column(
  //                                               children: [
  //                                                 Text(
  //                                                   aboutUs!
  //                                                       .data!
  //                                                       .services![i]
  //                                                       .service
  //                                                       .toString(),
  //                                                   style: TextStyle(
  //                                                     color: serviceIndex ==
  //                                                         i
  //                                                         ? Color(
  //                                                         0xFF3c9f9a)
  //                                                         : Color(
  //                                                         0xFF717171),
  //                                                   ),
  //                                                 ),
  //                                                 SizedBox(
  //                                                   height: 5,
  //                                                 ),
  //                                                 serviceIndex == i
  //                                                     ? Container(
  //                                                   decoration:
  //                                                   BoxDecoration(
  //                                                     borderRadius:
  //                                                     BorderRadius
  //                                                         .circular(
  //                                                         5),
  //                                                     color: Color(
  //                                                         0xFF3c9f9a),
  //                                                   ),
  //                                                   height: 3,
  //                                                   width: MediaQuery.of(
  //                                                       context)
  //                                                       .size
  //                                                       .width *
  //                                                       .2,
  //                                                 )
  //                                                     : Container(),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                             ],
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 20,right: 20,top: 15),
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: Color(0xFF96b2b5)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(20),
  //                               child: Column(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.start,
  //                                 crossAxisAlignment:
  //                                 CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                       aboutUs!.data!.services![serviceIndex].service.toString(),
  //                                       style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 18)),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   Text(
  //                                     aboutUs!.data!.services![serviceIndex].serviceDescription.toString(),
  //                                     style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontWeight: FontWeight.w400,
  //                                         fontSize: 15),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 20,
  //                         ),
  //                       ],
  //                     ),
  //                   if (selectedIndex == 3)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 20),
  //                       child: Container(
  //                           child: ListView.builder(
  //                               shrinkWrap: true,
  //                               physics: NeverScrollableScrollPhysics(),
  //                               itemBuilder: (context, index) {
  //                                 final List<YoutubePlayerController> _controllers = [
  //                                   for(int i=0;i<aboutUs!.data!.video!.length;i++)
  //                                     aboutUs!.data!.video![i],
  //                                 ].map<YoutubePlayerController>(
  //                                       (videoId) => YoutubePlayerController(
  //                                     initialVideoId: videoId,
  //                                     flags: const YoutubePlayerFlags(
  //                                       autoPlay: false,
  //                                     ),
  //                                   ),
  //                                 ).toList();
  //                                 return Padding(
  //                                   padding: const EdgeInsets.only(left: 20, right: 20,bottom: 20),
  //                                   child: InkWell(
  //                                     onTap: () {
  //
  //                                     },
  //                                     child: YoutubePlayer(
  //                                       key: ObjectKey(_controllers[index]),
  //                                       controller: _controllers[index],
  //                                       actionsPadding: const EdgeInsets.only(left: 16.0),
  //                                       bottomActions: [
  //                                         CurrentPosition(),
  //                                         const SizedBox(width: 10.0),
  //                                         ProgressBar(isExpanded: true),
  //                                         const SizedBox(width: 10.0),
  //                                         RemainingDuration(),
  //                                         FullScreenButton(),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );},
  //                               itemCount:aboutUs!.data!.video!.length)),
  //                     ),
  //                   Container(
  //                     alignment: Alignment.centerLeft,
  //                     margin: EdgeInsets.only(left: 20, right: 15),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text("Design ideas for your home",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 18)),
  //                         SizedBox(
  //                           height: 10,
  //                         ),
  //                         Text(
  //                             "Find design style and inspiring ideas for your dream house",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w500,
  //                                 fontSize: 14,
  //                                 color: Color(0xFF717171))),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 20, right: 20, top: 20),
  //                     child: Container(
  //                       height: 180,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           image: DecorationImage(
  //                             image: AssetImage(Assets.banner2),
  //                             fit: BoxFit.fill,
  //                           )),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             // Add more cards or widgets as needed
  //           ]),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
