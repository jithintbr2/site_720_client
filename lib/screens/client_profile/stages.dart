import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:site720_client/settings/config.dart';
import 'package:timelines_plus/timelines_plus.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({super.key});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  StageListModel? stages;
  bool? result = true;
  String token = "";

  @override
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
    stages = await HttpService.getStageList(token);
    if (stages != null) {
      setState(() {});
    }
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
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text("Stages"),
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
              body: stages != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: stages!.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TimelineTile(
                                  nodeAlign: TimelineNodeAlign.start,
                                  node: TimelineNode(
                                    indicator: DotIndicator(
                                      color: Colors.black,
                                    ),
                                    startConnector: index == 0
                                        ? null
                                        : SolidLineConnector(
                                            color: Config.themeColor),
                                    endConnector:
                                        index == stages!.data.length - 1
                                            ? null
                                            : SolidLineConnector(
                                                color: Config.themeColor),
                                  ),
                                  contents: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Card(
                                      color: stages!.data[index].stageSts ==
                                              "pending"
                                          ? Colors.orange.shade50
                                          : stages!.data[index].stageSts ==
                                                  "running"
                                              ? Colors.blue.shade100
                                              : stages!.data[index].stageSts ==
                                                      "completed"
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade100,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        stages!.data[index]
                                                            .stageName,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Config
                                                                .themeColor),
                                                      ),
                                                      if (stages!.data[index]
                                                              .startDate !=
                                                          "")
                                                        Text(
                                                          stages!.data[index]
                                                              .startDate,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Config
                                                                  .themeColor),
                                                        ),
                                                    ],
                                                  ),
                                                  Transform.scale(
                                                    scale: .7,
                                                    child: Switch(
                                                      value: false,
                                                      onChanged: (bool value) {
                                                        setState(() {});
                                                      },
                                                      activeTrackColor: Colors
                                                          .purple
                                                          .withOpacity(0.2),
                                                      inactiveThumbColor:
                                                          Colors.grey,
                                                      inactiveTrackColor: Colors
                                                          .grey
                                                          .withOpacity(0.2),
                                                      // Other properties
                                                      thumbIcon:
                                                          WidgetStateProperty
                                                              .resolveWith<
                                                                      Icon?>(
                                                                  (states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .selected)) {
                                                          return Icon(
                                                              Icons
                                                                  .lock_rounded,
                                                              size: 14);
                                                        }
                                                        return Icon(
                                                            Icons.lock_open,
                                                            size: 14);
                                                      }),
                                                      overlayColor:
                                                          WidgetStateProperty
                                                              .resolveWith<
                                                                      Color>(
                                                                  (states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .pressed)) {
                                                          return Colors.purple
                                                              .withOpacity(0.1);
                                                        }
                                                        return Colors
                                                            .transparent;
                                                      }),
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if (stages!
                                                      .data[index].startDate !=
                                                  "")
                                                Text(
                                                  "Scheduled Date : ${stages!.data[index].startDate}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Config.themeColor),
                                                ),
                                              if (stages!.data[index].endDate !=
                                                  "")
                                                Text(
                                                  "End Date : ${stages!.data[index].endDate}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Config.themeColor),
                                                ),
                                              Text(
                                                "status : ${stages!.data[index].stageSts}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Config.themeColor),
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.end,
                                              //   children: [
                                              //     CircleAvatar(
                                              //         backgroundColor:
                                              //             Colors.white,
                                              //         radius: 14,
                                              //         child: Icon(
                                              //           Icons.edit,
                                              //           size: 18,
                                              //           color: Colors.blue,
                                              //         )),
                                              //     SizedBox(
                                              //       width: 5,
                                              //     ),
                                              //     CircleAvatar(
                                              //         backgroundColor:
                                              //             Colors.white,
                                              //         radius: 14,
                                              //         child: Icon(
                                              //           Icons.delete,
                                              //           color: Colors.red,
                                              //           size: 18,
                                              //         )),
                                              //   ],
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
