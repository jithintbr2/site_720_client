import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/schedule_payment_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class SchedulePayment extends StatefulWidget {
  const SchedulePayment({super.key});

  @override
  State<SchedulePayment> createState() => _SchedulePaymentState();
}

class _SchedulePaymentState extends State<SchedulePayment> {
  SchedulePaymentModel? paymentList;
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
      setState(() => result = true);
    } else {
      setState(() => result = false);
    }
    paymentList = await HttpService.getClientScheduledPayment(token);
    if (paymentList != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async => getData(),
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  "Payments Scheduled",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(Assets.h4logo, height: 28, width: 28),
                  ),
                ],
              ),
              body: paymentList != null
                  ? ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: paymentList!.data.length,
                      itemBuilder: (context, index) {
                        final item = paymentList!.data[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: const Color(0xFF876B6F),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Phase & Status Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Phase ${item.phaseNo}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: item.status == 'Open'
                                            ? const Color(0xFF5f8d4e)
                                            : Colors.red,
                                      ),
                                      child: Text(
                                        item.status ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                /// Description
                                Text(
                                    "Stage: ${ item.description}",
                                  //item.description ?? "",
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 16),

                                /// Amounts Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _amountBox("Estimated", item.estCost),
                                    _amountBox("Paid", item.paidAmount),
                                    _amountBox("Balance", item.balanceAmount),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: BottomNavigationBarScreen(),
            ),
          )
        : _noNetworkWidget();
  }

  Widget _amountBox(String label, dynamic value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.26,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

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
              'No Network Found!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () => getData(),
              child: const Text(
                'Try Again',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            )
          ],
        ),
      ),
    );
  }
}
