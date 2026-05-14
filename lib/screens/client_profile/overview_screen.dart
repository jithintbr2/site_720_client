import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/client_by_id.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  ClientByIdModel? profilePage;
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
    profilePage = await HttpService.getClientByID(token);
    if (profilePage != null) {
      setState(() {});
    }
  }

  Widget buildStatCard(
    String title,
    String value,
    IconData icon, // 🔹 new param
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: textColor), // 🔹 icon added
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCardLarge(
      String title, String value, Color bgColor, Color textColor,
      {double width = 180}) {
    return Container(
      width: width, // 👈 added width
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
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
                elevation: 1,
                iconTheme: const IconThemeData(
                    color: Color.fromARGB(255, 255, 255, 255)),
                title: const Text("Overview",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold)),
                // actions: [
                //   Padding(
                //     padding: const EdgeInsets.only(right: 20),
                //     child: Container(
                //       height: 28,
                //       width: 28,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage(Assets.h4logo),
                //           fit: BoxFit.fitWidth,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ),
              body: profilePage != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              buildStatCard(
                                "Total Project Cost",
                                "₹${profilePage!.data.totalCost ?? "0"}",
                                Icons.business,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                              buildStatCard(
                                "Total Pkg Cost",
                                "₹${profilePage!.data.estimatedCost ?? "0"}",
                                Icons.attach_money,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                              buildStatCard(
                                "Received From Client",
                                "₹${profilePage!.data.receivedFrom ?? "0"}",
                                Icons.account_balance_wallet,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                              buildStatCard(
                                "Balance To Receive",
                                "₹${profilePage!.data.costPending ?? "0"}",
                                Icons.pending_actions,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                              buildStatCard(
                                "Total Extra Work",
                                "₹${profilePage!.data.totalExtraWork ?? "0"}",
                                Icons.work_history,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                              buildStatCard(
                                "Total Deduction",
                                "₹${profilePage!.data.totalDeduction ?? "0"}",
                                Icons.trending_down,
                                const Color.fromARGB(255, 241, 242, 243),
                                const Color.fromARGB(255, 53, 29, 29),
                              ),
                            ],
                          ),
                          // if (profilePage!.data.projectInfo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: buildProjectInfoSection(
                              profilePage!.data.projectInfo,
                              profilePage!.data.projectInfoTotal,
                              profilePage!.data.isFixed,
                              profilePage!.data.fixedRate,
                            ),
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              profilePage!.data.textDetails.toString(),
                              style: const TextStyle(
                                  color: Color(0xFF717171),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          if (profilePage!.data.isFreezed == "Y") ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF876B6F),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("FREEZED",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        const SizedBox(height: 6),
                                        Text(
                                            "No of days : ${profilePage!.data.freezedDiff}",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        const SizedBox(height: 4),
                                        const Text("Reason: Payment Delay",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 14, color: Colors.black),
                                        const SizedBox(width: 6),
                                        Text(profilePage!.data.freezedDate,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: BottomNavigationBarScreen(
                token: token,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.noNetwork, width: 250),
                  const SizedBox(height: 16),
                  const Text('No Network Found !',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    onPressed: getData,
                    child: const Text('Try Again',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          );
  }
}

Widget buildProjectInfoSection(List<ProjectInfo> projectInfo,
    ProjectInfoTotal? total, String isFixed, String fixedRate) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Project Information (${isFixed == "Y" ? "Fixed Rate" : "Unit Based Rate"})",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 12),
      fixedRate == ""
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 221, 192, 199),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                            flex: 2,
                            child: Text("Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Expanded(
                            flex: 2,
                            child: Text("Sq.Feet",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Expanded(
                            flex: 2,
                            child: Text("Rate",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Expanded(
                            flex: 3,
                            child: Text("Total",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ],
                    ),
                  ),
                  ...projectInfo.map((info) => Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(info.sqftName,
                                    style: const TextStyle(
                                        color: Colors.black87))),
                            Expanded(flex: 2, child: Text(info.sqftVal)),
                            Expanded(
                                flex: 2,
                                child: Text("₹${info.sqftRate}",
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis))),
                            Expanded(
                                flex: 3,
                                child: Text("₹${info.sqftTotal}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis))),
                          ],
                        ),
                      )),
                  if (total != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Text("Total",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text(total.totalSqft)),
                          Expanded(
                              flex: 2, child: Text("Avg ₹${total.avgRate}")),
                          Expanded(
                              flex: 3,
                              child: Text("₹${total.totalAmount}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                ],
              ),
            )
          : Text(
              "Fixed Rate: ₹$fixedRate",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold),
            ),
    ],
  );
}
