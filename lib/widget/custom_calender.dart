import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/workDateModel.dart';
import '../screens/client_profile/work_details_status.dart';
import '../service/service.dart';
import '../settings/common.dart';

class CustomCalendarWidget extends StatefulWidget {
  const CustomCalendarWidget({super.key});

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  WorkDatesModel? workDates;
  bool? result = true;
  String token = "";
  DateTime selectedDate = DateTime.now();

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

      workDates = await HttpService.getWorkDates(
          token, selectedDate.year, selectedDate.month);
      if (workDates != null) {
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
    if (workDates == null) {
      return Center(child: CircularProgressIndicator());
    }
    Set<String> workedDates = workDates!.data.workedDays
        .map((workDate) => DateFormat('yyyy-MM-dd').format(workDate))
        .toSet();

    Set<String> nonWorkedDates = workDates!.data.nonWorkedDays
        .map((workDate) => DateFormat('yyyy-MM-dd').format(workDate))
        .toSet();

    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month - 1);
                    getData();
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month + 1);
                    getData();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: _getDaysInMonth(selectedDate.year, selectedDate.month),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                DateTime date =
                    DateTime(selectedDate.year, selectedDate.month, index + 1);
                String dateStr = DateFormat('yyyy-MM-dd').format(date);
                Color backgroundColor;

                if (workedDates.contains(dateStr)) {
                  backgroundColor = Colors.green;
                } else if (nonWorkedDates.contains(dateStr)) {
                  backgroundColor = Colors.red;
                } else {
                  backgroundColor = Colors.grey;
                }

                return GestureDetector(
                  onTap: () {
                    // If the date is worked or non-worked, navigate to the WorkedDayDetailsPage
                    if (workedDates.contains(dateStr) || nonWorkedDates.contains(dateStr)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkedDayDetailsPage(
                            selectedDate: date, // Pass the date as it is
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
