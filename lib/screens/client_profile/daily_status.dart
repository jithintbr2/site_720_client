import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/work_updation_model.dart';
import 'package:site720_client/model/labourCountModel.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:site720_client/widget/laburGraphWidget.dart';
import '../../widget/custom_calender.dart';

class DailyStatus extends StatefulWidget {
  final String projectId;

  const DailyStatus(this.projectId, {super.key});

  @override
  State<DailyStatus> createState() => _DailyStatusState();
}

class _DailyStatusState extends State<DailyStatus> {
  ClientWorkStatusModel? workStatus;
  bool? result = true;
  String token = "";
  GetCountLabours? countData;
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
      setState(() => result = true);
    } else {
      setState(() => result = false);
    }

    workStatus = await HttpService.getWorkStatus(token);
    countData = await HttpService.getCountData(token, widget.projectId);

    if (workStatus != null) setState(() {});
  }

  void showCustomCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const CustomCalendarWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async => getData(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color(0xFFC24B68),
                foregroundColor: Colors.white,
                elevation: 1,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Daily Status",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                    onPressed: () => showCustomCalendar(context),
                  ),
                ],
              ),
              body: workStatus != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          //  const LabourGraphWidget(),
                          countData != null && countData!.data.isNotEmpty
                              ? LabourGraphWidget(data: countData!.data)
                              : const SizedBox.shrink(),
                          const SizedBox(height: 20),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workStatus!.data.length,
                            itemBuilder: (context, i) {
                              final data = workStatus!.data[i];
                              bool isWorking =
                                  data.isWorking.toString().toLowerCase() ==
                                      "yes";

                              Color containerColor = isWorking
                                  ? const Color.fromARGB(255, 149, 173, 150)
                                  : const Color.fromARGB(255, 155, 89, 97);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                color: containerColor,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Left side details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_today,
                                                    color: Color.fromARGB(
                                                        221, 253, 253, 253),
                                                    size: 18),
                                                const SizedBox(width: 8),
                                                Text(
                                                  data.workDate.toString(),
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        221, 247, 247, 247),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Stage: ${data.stageName}",
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    221, 255, 255, 255),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Description: ${data.description}",
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Right side stats
                                      Column(
                                        children: [
                                          _buildCircleInfo(
                                            label: "Labours",
                                            value: data.totalLabours.toString(),
                                            bgColor: Colors.blue.shade100,
                                            textColor: Colors.blue.shade800,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildCircleInfo(
                                            label: "Worked",
                                            value: isWorking ? "Yes" : "No",
                                            bgColor: isWorking
                                                ? Colors.green.shade200
                                                : Colors.red.shade200,
                                            textColor: isWorking
                                                ? Colors.green.shade800
                                                : Colors.red.shade800,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: BottomNavigationBarScreen(token:token),
            ),
          )
        : _noNetworkWidget();
  }

  /// Circle Info Widget
  Widget _buildCircleInfo({
    required String label,
    required String value,
    required Color bgColor,
    required Color textColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(221, 255, 255, 255),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// No Network Widget
  Widget _noNetworkWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.noNetwork, width: 220, height: 220),
            const SizedBox(height: 20),
            const Text(
              'No Network Found !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: getData,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Try Again",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}