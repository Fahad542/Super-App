import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieCharNewData {
  final String title;

  PieCharNewData({required this.title});
}

class PieCharNew extends StatelessWidget {
  final Map<String, double> dataMap;

  const PieCharNew({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      colorList: [
        Color(0xff0a406b),
        Color(0xffe0271b),
        Color(0xFF80CBC4),
      ],
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle:
              TextStyling.mediumBold.copyWith(color: AppColors.primary)),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: false,
        chartValueStyle:
            TextStyling.mediumRegular.copyWith(color: AppColors.white),
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
