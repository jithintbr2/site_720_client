import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/villaProjectModel.dart';
import '../service/service.dart';
import '../settings/assets.dart';
import 'bottomNavigationBarScreen.dart';

class VillaProjectListPage extends StatefulWidget {
  String? token;
  VillaProjectListPage({this.token, Key? key}) : super(key: key);
  @override
  State<VillaProjectListPage> createState() => _VillaProjectListPageState();
}

class _VillaProjectListPageState extends State<VillaProjectListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool? result = true;
  bool? result1 = true;
  VillaProjectModel? villaProjects;
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
    villaProjects = await HttpService.villaProjectList();
    if (villaProjects != null) {
      setState(() {
        _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
          if (_currentPage < villaProjects!.data!.images!.length - 1) {
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
                title: Text('Villa Projects'),
              ),
              body: villaProjects != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10,
                            ),
                            Container(
                              height: 200,
                              child: PageView.builder(
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: villaProjects!.data!.images!.length,
                                itemBuilder:
                                    (BuildContext context, int itemIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        imageUrl: villaProjects!
                                            .data!.images![itemIndex]
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
                            Text(
                              villaProjects!.data!.heading.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ExpandableText(
                              villaProjects!.data!.overviewDescription
                                  .toString(),
                              expandText: 'Read more',
                              collapseText: 'Read less',
                              maxLines: 5,
                              linkColor: Colors.blue,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Videos',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final List<YoutubePlayerController>
                                          _controllers = [
                                        for (int i = 0;
                                            i <
                                                villaProjects!
                                                    .data!.youtubeLinks!.length;
                                            i++)
                                          villaProjects!.data!.youtubeLinks![i],
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
                                            key: ObjectKey(_controllers[index]),
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
                                    itemCount: villaProjects!
                                        .data!.youtubeLinks!.length)),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar:
                  BottomNavigationBarScreen(token: widget.token),
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
