import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site720_client/model/client_details/extra_work.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/common.dart';
import '../../model/client_details/extrawork_dates_model.dart';

class WorkedDayDetailsPage extends StatefulWidget {
  final DateTime selectedDate;
  const WorkedDayDetailsPage({super.key, required this.selectedDate});
  @override
  State<WorkedDayDetailsPage> createState() => _WorkedDayDetailsPageState();
}

class _WorkedDayDetailsPageState extends State<WorkedDayDetailsPage> {
  ExtraworkDates? extraWorks;
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

      extraWorks = await HttpService.getClientExtraWorkForDate(
        token,
        widget.selectedDate,
      );

      if (extraWorks != null) {
        setState(() {});
      }
    } else {
      setState(() {
        result = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Status'),
      ),
      body: extraWorks == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: extraWorks!.data.length,
              itemBuilder: (context, index) {
                var work = extraWorks!.data[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF876B6F),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 8, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            work.workDate,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Text(
                                      //   work.projectName,
                                      //   style: const TextStyle(
                                      //       color: Colors.white,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 16),
                                      // ),
                                      Text(
                                        "Stage: ${work.stageName}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),

                                      // Text(
                                      //   "Is Working: ${work.isWorking}",
                                      //   style: const TextStyle(
                                      //       color: Colors.white, fontSize: 14),
                                      // ),
                                      work.isWorking == "No"
                                          ? Text(
                                              "Issue: ${work.workStatusOrLabourNo}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            )
                                          : SizedBox(),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Remark:${work.description}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                work.isWorking == "Yes"
                                    ? Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Labour No',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  work.workStatusOrLabourNo
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox
                                        .shrink(), 
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
