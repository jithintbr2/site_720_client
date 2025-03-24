import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({Key? key}) : super(key: key);

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  StageListModel? stages;
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
              return null;
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
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: stages!.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xFF96b2b5)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          stages!.data[index].stageName
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: stages!.data[index]
                                                          .stageSts ==
                                                      "completed"
                                                  ? Color(0xFF5f8d4e)
                                                  : stages!.data[index]
                                                              .stageSts ==
                                                          "pending"
                                                      ? Colors.red
                                                      : Colors.blue),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Center(
                                              child: Text(
                                                  stages!.data[index].stageSts,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Start date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontSize: 9),
                                                ),
                                                Text(
                                                  stages!.data[index].startDate
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              children: [
                                                const Text('End date',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontSize: 9)),
                                                Text(
                                                    stages!.data[index].endDate
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              children: [
                                                const Text('Completed date',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontSize: 9)),
                                                Text(
                                                  stages!.data[index]
                                                          .isCompleted
                                                      ? stages!.data[index]
                                                          .completedDate
                                                          .toString()
                                                      : "-",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
