import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/get_icons.dart';
import 'package:site720_client/model/getPrecetageModel.dart';
import 'package:site720_client/screens/client_profile/daily_status.dart';
import 'package:site720_client/screens/client_profile/deduction_work_screen.dart';
import 'package:site720_client/screens/client_profile/documentPage.dart';
import 'package:site720_client/screens/client_profile/drawings_screen.dart';
import 'package:site720_client/screens/client_profile/extra_works_screen.dart';
import 'package:site720_client/screens/client_profile/gallery_screen.dart';
import 'package:site720_client/screens/client_profile/overview_screen.dart';
import 'package:site720_client/screens/client_profile/package_screen.dart';
import 'package:site720_client/screens/client_profile/payment_list_screen.dart';
import 'package:site720_client/screens/client_profile/phase_video_screen.dart';
import 'package:site720_client/screens/client_profile/schedule_payment.dart';
import 'package:site720_client/screens/client_profile/stages.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../bottomNavigationBarScreen.dart';

class ProfilePage extends StatefulWidget {
  String token;
  ProfilePage(this.token, {super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GetIconsModel? iconsList;
  GetPercentModel? percentList;
  bool? result = true;
  String? name;

  @override
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
    //percentList = await HttpService.getGraphData(widget.token,iconsList?.data.projectId ?? "");
    if (iconsList?.data.projectId != null &&
        iconsList!.data.projectId.isNotEmpty) {
      percentList = await HttpService.getGraphData(
        widget.token,
        iconsList!.data.projectId,
      );
    } else {
      print("Project ID is null or empty");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                iconsList?.data.clientName ?? "Project Details",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 110, 69, 69),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            body: iconsList != null
                ? RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      return;
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ProjectStagesPieChart(
                                  percentList: percentList),
                            ),
                          ),

                          // Card(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10)),
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 16, vertical: 8),
                          //   elevation: 3,
                          //   child: const ListTile(
                          //     leading: Icon(Icons.calendar_month,
                          //         color: Color.fromARGB(255, 110, 69, 69)),
                          //     title: Text(
                          //       "Remaining Days: 45",
                          //       style: TextStyle(
                          //           fontSize: 16, fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 16),
                          iconsList!.data.icons.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 100.0),
                                  child: Center(
                                      child: Text(
                                          "Currently you have no running projects!")),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            childAspectRatio: 1.05),
                                    itemCount: iconsList!.data.icons.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          final id = iconsList!
                                              .data.icons[index].iconId;
                                          if (id == "1") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => DailyStatus(
                                                        iconsList!
                                                            .data.projectId)));
                                          } else if (id == "2") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DrawerScreen()));
                                          } else if (id == "3") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ExtraWorksScreen()));
                                          } else if (id == "4") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        GalleryScreen()));
                                          } else if (id == "5") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        PackageScreen()));
                                          } else if (id == "6") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        PaymentListScreen()));
                                          } else if (id == "7") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        SchedulePayment()));
                                          } else if (id == "8") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        VideoScreen()));
                                          } else if (id == "9") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        StageScreen()));
                                          } else if (id == "10") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DeductionWorkScreen()));
                                          } else if (id == "11") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        OverviewScreen()));
                                          } else if (id == "12") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DocumentPage(
                                                  projectId: iconsList!.data
                                                      .projectId, // ✅ use named argument
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 218, 179, 179),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(2, 3),
                                                blurRadius: 4,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                width: 45,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.contain,
                                                  imageUrl: iconsList!
                                                      .data.icons[index].iconUrl
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                iconsList!
                                                    .data.icons[index].iconName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
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
                : const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBarScreen(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.noNetwork, width: 200),
                  const SizedBox(height: 16),
                  const Text(
                    'No Network Found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400),
                    onPressed: () => getData(),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class ProjectStagesPieChart extends StatefulWidget {
  final GetPercentModel? percentList;

  const ProjectStagesPieChart({super.key, this.percentList});

  @override
  State<ProjectStagesPieChart> createState() => _ProjectStagesPieChartState();
}

class _ProjectStagesPieChartState extends State<ProjectStagesPieChart> {
  _StageData? selectedStage;
  Color getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.yellow;
      case "green":
        return Colors.green;
      case "orange":
        return Colors.orange;
      case "purple":
        return Colors.purple;
      case "teal":
        return Colors.teal;
      case "pink":
        return Colors.pink;
      case "brown":
        return Colors.brown;
      case "grey":
      case "gray":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_StageData> data = widget.percentList?.data.map((e) {
          return _StageData(
            e.stageName,
            e.percentComplete,
            getColorFromName(e.color),
            e.daysLeft,
          );
        }).toList() ??
        [];

    int total = data.fold(0, (sum, item) => sum + item.percentage);

    return data.isEmpty
        ? const Center(child: Text("No stage data available"))
        : Row(
            children: [
              SizedBox(
                height: 220,
                width: 220,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  legend: Legend(isVisible: false),
                  series: <CircularSeries>[
                    DoughnutSeries<_StageData, String>(
                      dataSource: data,
                      pointColorMapper: (datum, _) => datum.color,
                      xValueMapper: (datum, _) => datum.stage,
                      yValueMapper: (datum, _) => datum.percentage,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      innerRadius: '70%',
                      radius: '100%',
                      onPointTap: (ChartPointDetails details) {
                        setState(() {
                          selectedStage = data[details.pointIndex!];
                        });
                      },
                    ),
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$total%",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Completed",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: selectedStage == null
                    ? const Text(
                        "Tap on a stage to see details",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedStage!.stage,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${selectedStage!.percentage}%",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          if (selectedStage!.daysLeft.isNotEmpty)
                            Text(
                              "${selectedStage!.daysLeft} days left",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                        ],
                      ),
              )
            ],
          );
  }
}

class _StageData {
  final String stage;
  final int percentage;
  final Color color;
  final String daysLeft;

  _StageData(this.stage, this.percentage, this.color, this.daysLeft);
}
