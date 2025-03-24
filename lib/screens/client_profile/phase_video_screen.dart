import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/phase_video_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  PhaseVideoModel? videoData;
  bool? result = true;
  int vedioIndex = 0;
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
    videoData = await HttpService.getClientPhasesVideo(token);
    if (videoData != null) {
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
                title: Text("Videos"),
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
              body: videoData != null
                  ? SingleChildScrollView(
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
                                for (int i = 0; i < videoData!.data.length; i++)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        vedioIndex = i;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 0),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  videoData!.data[i].phaseNo
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: vedioIndex == i
                                                        ? Color(0xFF3c9f9a)
                                                        : Color(0xFF717171),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                vedioIndex == i
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color:
                                                              Color(0xFF3c9f9a),
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
                                  itemBuilder: (context, index) {
                                    final List<YoutubePlayerController>
                                        _controllers = [
                                      for (int i = 0;
                                          i <
                                              videoData!.data[vedioIndex]
                                                  .phaseVideo.length;
                                          i++)
                                        videoData!
                                            .data[vedioIndex].phaseVideo[i],
                                    ]
                                            .map<YoutubePlayerController>(
                                              (videoId) =>
                                                  YoutubePlayerController(
                                                initialVideoId: videoId,
                                                flags: const YoutubePlayerFlags(
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
                                              const EdgeInsets.only(left: 16.0),
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
                                  itemCount: videoData!
                                      .data[vedioIndex].phaseVideo.length)),
                          SizedBox(
                            height: 20,
                          ),
                        ],
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
