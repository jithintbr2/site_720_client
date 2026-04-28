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

import '../../utils/youtube_utils.dart';
import '../../widget/youtube_player_widget.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GalleryModel? gallery;
  bool? result = true;
  String? name;
  String token = "";
  int galleryIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              getData();
              return;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(248, 218, 177, 188),
                iconTheme: IconThemeData(
                  color: const Color.fromARGB(255, 255, 255, 255), //change your color here
                ),
                title: Text("Gallery",style: TextStyle(color: Colors.white)),
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
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (gallery == null || gallery!.status == false || gallery!.data.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Assets.noResult),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                gallery?.message ?? "No Gallery Items Found!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  gallery?.status == false 
                                    ? "We couldn't retrieve the gallery at this time. Please try again later."
                                    : "It seems there are no photos or videos available for this site at the moment.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => getData(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(248, 218, 177, 188),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : Padding(
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
                                                        fontSize: 12),
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
                                            child: isYoutubeLink(gallery!
                                                    .data[galleryIndex]
                                                    .phaseImages[index])
                                                ? YoutubePlayerBuilderWidget(
                                                    videoUrl: gallery!
                                                        .data[galleryIndex]
                                                        .phaseImages[index],
                                                  )
                                                : SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 220,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                        imageUrl: gallery!
                                                            .data[galleryIndex]
                                                            .phaseImages[index]
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                        placeholder: (_, __) =>
                                                            Center(
                                                          child: Lottie.asset(
                                                            'assets/images/loading.json',
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        errorWidget:
                                                            (_, __, ___) =>
                                                                Center(
                                                          child: Icon(
                                                              Icons.error,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

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
                    ),
              bottomNavigationBar: BottomNavigationBarScreen(token:token),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
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
                    child: SizedBox(
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
