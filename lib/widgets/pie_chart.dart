import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

class CustomPieChart extends StatelessWidget {
  final double confidence;

  CustomPieChart({required this.confidence});

  @override
  Widget build(BuildContext context) {
    return pie.PieChart(
      dataMap: {
        "Confidence": confidence,
        "Remaining": 1 - confidence,
      },
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 0,
      chartRadius: 30, // Reduced size
      colorList: [Colors.blue, Colors.grey.withOpacity(0.3)],
      initialAngleInDegree: 0,
      chartType: pie.ChartType.ring,
      ringStrokeWidth: 4, // Thinner ring
      centerText:
          "${(confidence * 100).toStringAsFixed(0)}%", // Removed decimal
      centerTextStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      legendOptions: pie.LegendOptions(
        showLegendsInRow: false,
        legendPosition: pie.LegendPosition.right,
        showLegends: false,
      ),
      chartValuesOptions: pie.ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
