import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site720_client/model/labourCountModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LabourGraphWidget extends StatelessWidget {
  final List<LaboursCount> data;

  const LabourGraphWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<_LabourData> chartData = data.map((e) {
      return _LabourData(
        day: _formatDate(e.workDate),
        labours: int.tryParse(e.laboursNo) ?? 0,
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: SizedBox(
          width: chartData.length * 50,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelRotation: -45,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Number of Labours'),
              minimum: 0,
              interval: 5,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ColumnSeries<_LabourData, String>>[
              ColumnSeries<_LabourData, String>(
                dataSource: chartData,
                xValueMapper: (_LabourData data, _) => data.day,
                yValueMapper: (_LabourData data, _) => data.labours,
                name: 'Labours',
                pointColorMapper: (_LabourData data, int index) {
                  if (index == 0) return Colors.green;
                  // return Colors.blue.shade400;
                    return Color.fromARGB(248, 218, 177, 188);
                },
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(String dateString) {
    try {
      final DateTime parsed = DateFormat("dd-MM-yyyy").parse(dateString);
      return DateFormat("d MMM").format(parsed);
    } catch (e) {
      return dateString;
    }
  }
}

class _LabourData {
  final String day;
  final int labours;
  _LabourData({required this.day, required this.labours});
}