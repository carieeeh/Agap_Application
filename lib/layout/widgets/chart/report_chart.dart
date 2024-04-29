import 'package:agap_mobile_v01/global/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportChart extends StatefulWidget {
  const ReportChart({super.key});

  @override
  State<ReportChart> createState() => _ReportChartState();
}

class _ReportChartState extends State<ReportChart> {
  //https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample7.dart

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 18,
          top: 10,
          bottom: 4,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 1),
                  FlSpot(1, 2),
                  FlSpot(2, 3),
                  FlSpot(3, 4),
                  FlSpot(4, 5),
                  // FlSpot(5, 6),
                  // FlSpot(6, 6.5),
                  // FlSpot(7, 6),
                  // FlSpot(8, 4),
                  // FlSpot(9, 6),
                  // FlSpot(10, 6),
                  // FlSpot(11, 7),
                ],
                color: primaryRed,
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2),
                  FlSpot(1, 3),
                  FlSpot(2, 4),
                  FlSpot(3, 2),
                  FlSpot(4, 10),
                  // FlSpot(5, 4),
                  // FlSpot(6, 5),
                  // FlSpot(7, 5),
                  // FlSpot(8, 6),
                  // FlSpot(9, 8),
                  // FlSpot(10, 1),
                  // FlSpot(11, 3),
                ],
                color: primaryBlue,
              ),
            ],
            // betweenBarsData: [
            //   BetweenBarsData(
            //     fromIndex: 0,
            //     toIndex: 1,
            //     color: gray,
            //   )
            // ],
            minY: 0,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  interval: 1,
                  reservedSize: 36,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              // checkToShowHorizontalLine: (double value) {
              //   return value == 1 || value == 6 || value == 4 || value == 5;
              // },
            ),
          ),
        ),
      ),
    );
  }
}
