import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// ✅ Interactive Pie Chart Widget
class ProjectStagesPieChart extends StatefulWidget {
  const ProjectStagesPieChart({super.key});

  @override
  State<ProjectStagesPieChart> createState() => _ProjectStagesPieChartState();
}

class _ProjectStagesPieChartState extends State<ProjectStagesPieChart> {
  final List<_StageData> data = [
    _StageData("Soil Filling", 20, Colors.green),
    _StageData("Foundation", 30, Colors.orange),
    _StageData("Basement", 10, Colors.blue),
  ];

  _StageData? selectedStage;
  Timer? resetTimer;

  @override
  void dispose() {
    resetTimer?.cancel();
    super.dispose();
  }

  void _onStageSelected(_StageData stage) {
    setState(() {
      selectedStage = stage;
    });

    // cancel any old timer
    resetTimer?.cancel();

    // reset to total after 5 seconds
    resetTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          selectedStage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int total = data.fold(0, (sum, item) => sum + item.percentage);

    return SizedBox(
      height: 250,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        legend: Legend(isVisible: false),
        series: <CircularSeries>[
          DoughnutSeries<_StageData, String>(
            dataSource: data,
            pointColorMapper: (datum, _) => datum.color,
            xValueMapper: (datum, _) => datum.stage,
            yValueMapper: (datum, _) => datum.percentage,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            innerRadius: '70%',
            radius: '100%',
            onPointTap: (ChartPointDetails details) {
              _onStageSelected(data[details.pointIndex!]);
            },
          ),
        ],
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedStage == null
                      ? "$total%"
                      : "${selectedStage!.percentage}%",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  selectedStage == null ? "Completed" : selectedStage!.stage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StageData {
  final String stage;
  final int percentage;
  final Color color;

  _StageData(this.stage, this.percentage, this.color);
}
