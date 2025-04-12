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
  Map<int, bool> _isExpandedMap =
      {}; // This will store the expansion state for each stage

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    token = await Common.getSharedPref("token");
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    setState(() {
      result = connectivityResult.contains(ConnectivityResult.mobile) ||
              connectivityResult.contains(ConnectivityResult.wifi)
          ? true
          : false;
    });
    stages = await HttpService.getStageList(token);
    if (stages != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async => getData(),
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Text("Stagewise Schedule",
                    style: TextStyle(color: Colors.black)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.h4logo),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: stages != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: stages!.data.length,
                          itemBuilder: (context, index) {
                            final stage = stages!.data[index];
                            return Column(
                              children: [
                                TimelineTile(
                                  nodeAlign: TimelineNodeAlign.start,
                                  node: TimelineNode(
                                    indicator: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DotIndicator(color: Colors.black),
                                        const SizedBox(height: 6),
                                        Text(
                                          stage.startDate.isNotEmpty
                                              ? stage.startDate
                                              : '07-04-2025',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: stage.stageStatus == "pending"
                                          ? Colors.orange.shade50
                                          : stage.stageStatus == "running"
                                              ? Colors.blue.shade100
                                              : stage.stageStatus == "completed"
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade100,
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: GestureDetector(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        stage.stageName,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Config.themeColor,
                                                        ),
                                                      ),
                                                      if (stage
                                                          .startDate.isNotEmpty)
                                                        Text(
                                                          stage.startDate,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Config
                                                                .themeColor,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Transform.scale(
                                                    scale: .8,
                                                    child: Switch(
                                                      value: false,
                                                      onChanged: (bool value) =>
                                                          setState(() {}),
                                                      activeTrackColor: Colors
                                                          .purple
                                                          .withOpacity(0.2),
                                                      inactiveThumbColor:
                                                          Colors.grey,
                                                      inactiveTrackColor: Colors
                                                          .grey
                                                          .withOpacity(0.2),
                                                      thumbIcon:
                                                          WidgetStateProperty
                                                              .resolveWith<
                                                                  Icon?>(
                                                        (states) => states
                                                                .contains(
                                                                    WidgetState
                                                                        .selected)
                                                            ? const Icon(
                                                                Icons
                                                                    .lock_rounded,
                                                                size: 14)
                                                            : const Icon(
                                                                Icons.lock_open,
                                                                size: 14),
                                                      ),
                                                      overlayColor:
                                                          WidgetStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (states) => states
                                                                .contains(
                                                                    WidgetState
                                                                        .pressed)
                                                            ? Colors.purple
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              if (stage.startDate.isNotEmpty)
                                                Text(
                                                  "Scheduled Date : ${stage.startDate}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Config.themeColor,
                                                  ),
                                                ),
                                              if (stage.endDate.isNotEmpty)
                                                Text(
                                                  "End Date : ${stage.endDate}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Config.themeColor,
                                                  ),
                                                ),
                                              Text(
                                                "Status : ${stage.stageStatus}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Config.themeColor,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isExpandedMap[index] =
                                                            !(_isExpandedMap[
                                                                    index] ??
                                                                false);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 150,
                                                              top: 8),
                                                      child: stages!
                                                              .data[index]
                                                              .workDetails
                                                              .isNotEmpty
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      12,
                                                                      12,
                                                                      12),
                                                              size: 30,
                                                            )
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (_isExpandedMap[index] ??
                                                  false)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: SizedBox(
                                                    height: stages!
                                                            .data[index]
                                                            .workDetails
                                                            .length *
                                                        100.0,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: stages!
                                                          .data[index]
                                                          .workDetails
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      6.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    stages!
                                                                        .data[
                                                                            index]
                                                                        .workDetails[
                                                                            i]
                                                                        .workDate,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      letterSpacing:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  if (index !=
                                                                      4)
                                                                    Container(
                                                                      width: 2,
                                                                      height:
                                                                          50,
                                                                      color: Colors
                                                                          .blue
                                                                          .shade300,
                                                                    ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  width: 14),
                                                              Expanded(
                                                                child: ListTile(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0),
                                                                  title: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        stages!.data[index].workDetails[i].isWorking, 
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                               stages!.data[index].workDetails[i].isWorking=="Yes"?Colors.green:Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4),
                                                                      Text(
                                                                        stages!.data[index].workDetails[i].laboursNo.isNotEmpty &&
                                                                                stages!.data[index].workDetails[i].laboursNo != "0"
                                                                            ? 'Labour No:${stages!.data[index].workDetails[i].laboursNo}'
                                                                            : 'Status:${stages!.data[index].workDetails[i].workStatus}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          color:
                                                                              Colors.black87,
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                          letterSpacing:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle:
                                                                      Text(
                                                                    stages!
                                                                        .data[
                                                                            index]
                                                                        .workDetails[
                                                                            i]
                                                                        .description,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      letterSpacing:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
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
                  : const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: BottomNavigationBarScreen(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.noNetwork,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Network Found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: getData,
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

void _showStageDialog(BuildContext context, stage) {
  List<String> additionalNames = ["Ansar", "Sruthy", "Pradeesh", "Sarath"];
  List<String> additionalDates = [
    "2025-04-02",
    "2025-04-03",
    "2025-04-05",
    "2025-04-05"
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          stage.stageName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start Date: 12-05-2025"),
              Text("End Date: 25-05-2025"),
              const SizedBox(height: 12),
              Text("Additional Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: additionalNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF876B6F),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        additionalNames[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        additionalDates[index],
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
