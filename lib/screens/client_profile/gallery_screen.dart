import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/gallery.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/screens/fullImagePage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:lottie/lottie.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GalleryModel? gallery;
  bool? result = true;
  String? name;
  String token = "";
  int galleryIndex = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    name = await Common.getSharedPref("name");
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
    gallery = await HttpService.getGallery(token);
    if (gallery != null) {
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
                title: Text("Gallery"),
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
              body: gallery != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
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
                                  for (int i = 0; i < gallery!.data.length; i++)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          galleryIndex = i;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 0),
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
                                                    gallery!.data[i].phaseNo
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: galleryIndex == i
                                                          ? Color(0xFF3c9f9a)
                                                          : Color(0xFF717171),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  galleryIndex == i
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImagePage(gallery!
                                                            .data[galleryIndex]
                                                            .phaseImages[index])),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                height: 220,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      imageUrl: gallery!
                                                          .data[galleryIndex]
                                                          .phaseImages[index],
                                                      fit: BoxFit.cover,
                                                      placeholder: (_, __) =>
                                                          Center(
                                                            child: Lottie.asset(
                                                                'assets/images/loading.json',
                                                                fit: BoxFit
                                                                    .fill),
                                                          ),
                                                      errorWidget: (_, __,
                                                              ___) =>
                                                          Center(
                                                              child: Icon(
                                                                  Icons.error,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor))),
                                                )),
                                            // Container(
                                            //   height: 220,
                                            //   decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(10),
                                            //       image: DecorationImage(
                                            //         image: NetworkImage(profilePage!.data![galleryIndex].phaseImages![index]),
                                            //         fit: BoxFit.fill,
                                            //       )),
                                            // ),
                                          ),
                                        ),
                                    itemCount: gallery!.data[galleryIndex]
                                        .phaseImages.length)),
                            SizedBox(
                              height: 20,
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
