import 'package:agap_mobile_v01/global/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportChart extends StatefulWidget {
  const ReportChart({super.key});

  @override
  State<ReportChart> createState() => _ReportChartState();
}

class _ReportChartState extends State<ReportChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .4,
      width: Get.width,
      child: LineChart(
        LineChartData(
          maxY: 10,
          maxX: 5,
          minX: 0,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              color: primaryRed,
              spots: [
                const FlSpot(0, 0),
                const FlSpot(1, 4),
                const FlSpot(2, 3),
                const FlSpot(3, 5),
                const FlSpot(4, 9),
                const FlSpot(5, 7),
              ],
            ),
            LineChartBarData(
              color: primaryBlue,
              spots: [
                const FlSpot(0, 0),
                const FlSpot(1, 3),
                const FlSpot(2, 4),
                const FlSpot(3, 6),
                const FlSpot(4, 7),
                const FlSpot(5, 7),
              ],
            ),
            LineChartBarData(
              color: yellow,
              spots: [
                const FlSpot(0, 0),
                const FlSpot(1, 2),
                const FlSpot(2, 5),
                const FlSpot(3, 4),
                const FlSpot(4, 6),
                const FlSpot(5, 1),
              ],
            ),
            LineChartBarData(
              color: skyBlue,
              spots: [
                const FlSpot(0, 0),
                const FlSpot(1, 3),
                const FlSpot(2, 5),
                const FlSpot(3, 2),
                const FlSpot(4, 1),
                const FlSpot(5, 5),
              ],
            ),
            LineChartBarData(
              color: colorSuccess,
              spots: [
                const FlSpot(0, 0),
                const FlSpot(1, 8),
                const FlSpot(2, 6),
                const FlSpot(3, 2),
                const FlSpot(4, 3),
                const FlSpot(5, 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
