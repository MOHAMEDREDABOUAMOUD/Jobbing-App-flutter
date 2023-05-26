// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:signin_signup/pages/service.dart';
import 'package:signin_signup/services/business.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class Statistics extends StatefulWidget {
  final String email;
  const Statistics({Key? key, required this.email}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int touchedIndex = 0;
  List<double> demY = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10];
  double r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0, r8 = 0;

  @override
  void initState() {
    super.initState();
    print(
        "start**********************************************************************");
    loadData();
    print(
        "end**********************************************************************");
  }

  Future<void> loadData() async {
    List<Future<double>> demandesStatsFutures = [];
    List<double> serviceStats = [];
    List<double> demandesStats = [];
    try {
      List<Future<double>> serviceStatsFutures = [
        services.getServicesStats("Menage"),
        services.getServicesStats("Plomberie"),
        services.getServicesStats("Electricite"),
        services.getServicesStats("Babysitting"),
        services.getServicesStats("Renovation"),
        services.getServicesStats("Informatique"),
        services.getServicesStats("Jardinage"),
        services.getServicesStats("Demenagement"),
      ];

      for (var i = 1; i <= 12; i++) {
        demandesStatsFutures
            .add(services.getDemandesStatsOfYear(widget.email, i));
      }
      serviceStats = await Future.wait(serviceStatsFutures);
      demandesStats = await Future.wait(demandesStatsFutures);
      setState(() {
        demY = demandesStats;
        r1 = serviceStats[0];
        r2 = serviceStats[1];
        r3 = serviceStats[2];
        r4 = serviceStats[3];
        r5 = serviceStats[4];
        r6 = serviceStats[5];
        r7 = serviceStats[6];
        r8 = serviceStats[7];
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    BarData weekSummary = BarData(
        lun: 70, mar: 100, mer: 150, jeu: 200, ven: 50, sam: 100, dim: 300);
    weekSummary.init();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          toolbarHeight: 70,
          title: Text(
            "Smart Jobbing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mon revenu cette semaine",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      // graph 1 revenu par semaine
                      Center(
                        child: SizedBox(
                          height: 300,
                          child: Expanded(
                              child: BarChart(BarChartData(
                                  minY: 0,
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    rightTitles: AxisTitles(),
                                    topTitles: AxisTitles(),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: bottomTitles,
                                      ),
                                    ),
                                  ),
                                  barGroups: weekSummary.barData
                                      .map((e) => BarChartGroupData(
                                            x: e.x,
                                            barRods: [
                                              BarChartRodData(
                                                toY: e.y,
                                                color: Colors.grey[500],
                                                width: 20,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                backDrawRodData:
                                                    BackgroundBarChartRodData(
                                                        show: true,
                                                        toY: 300,
                                                        color:
                                                            Colors.grey[200]),
                                              )
                                            ],
                                          ))
                                      .toList()))),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Mes demandes cette année",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      // graph 2 demandes par annee
                      SizedBox(
                        height: 300,
                        child: Expanded(
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              minY: 0,
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(),
                                topTitles: AxisTitles(),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitlesMonth,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                      color: Colors.grey, strokeWidth: 3);
                                },
                                drawVerticalLine: true,
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  //les (x, y)
                                  spots: [
                                    FlSpot(0, demY[0]),
                                    FlSpot(1, demY[1]),
                                    FlSpot(2, demY[2]),
                                    FlSpot(3, demY[3]),
                                    FlSpot(4, demY[4]),
                                    FlSpot(5, demY[5]),
                                    FlSpot(6, demY[6]),
                                    FlSpot(7, demY[7]),
                                    FlSpot(8, demY[8]),
                                    FlSpot(9, demY[9]),
                                    FlSpot(10, demY[10]),
                                    FlSpot(11, demY[11]),
                                  ],
                                  isCurved: true,
                                  color: Colors.amber,
                                  barWidth: 3,
                                  //dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.amber.withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Nos services demandés",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // graph 3 services
                      SizedBox(
                        height: 300,
                        child: Expanded(
                            child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: showingSections(),
                          ),
                        )),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

//liste des services du graph 3
  List<PieChartSectionData> showingSections() {
    return List.generate(8, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 15.0;
      final radius = isTouched ? 130.0 : 120.0;
      final widgetSize = isTouched ? 50.0 : 35.0;
      //const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: r1,
            title: r1.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'lib/images/img/Menage.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.amber,
            value: r2,
            title: r2.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Plomberie.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.deepPurpleAccent,
            value: r3,
            title: r3.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Electricite.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.pinkAccent,
            value: r4,
            title: r4.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Babysitting.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: Colors.brown,
            value: r5,
            title: r5.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Renovation.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 5:
          return PieChartSectionData(
            color: Colors.lightBlueAccent,
            value: r6,
            title: r6.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Informatique.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 6:
          return PieChartSectionData(
            color: Colors.lightGreen,
            value: r7,
            title: r7.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Jardinage.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 7:
          return PieChartSectionData(
            color: Colors.orange,
            value: r8,
            title: r8.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/img/Demenagement.png',
              size: widgetSize,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception("");
      }
    });
  }
}

Widget bottomTitles(double v, TitleMeta t) {
  const style = TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.black,
  );
  Widget text = Text("");
  switch (v.toInt()) {
    case 0:
      text = const Text("Lun", style: style);
      break;
    case 1:
      text = const Text("Mar", style: style);
      break;
    case 2:
      text = const Text("Mer", style: style);
      break;
    case 3:
      text = const Text("Jeu", style: style);
      break;
    case 4:
      text = const Text("Ven", style: style);
      break;
    case 5:
      text = const Text("Sam", style: style);
      break;
    case 6:
      text = const Text("Dim", style: style);
      break;
  }
  return SideTitleWidget(axisSide: t.axisSide, child: text);
}

Widget bottomTitlesMonth(double v, TitleMeta t) {
  const style = TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.black,
  );
  Widget text = Text("");
  switch (v.toInt()) {
    case 0:
      text = const Text("Jan", style: style);
      break;
    case 1:
      text = const Text("Fev", style: style);
      break;
    case 2:
      text = const Text("Mar", style: style);
      break;
    case 3:
      text = const Text("Avr", style: style);
      break;
    case 4:
      text = const Text("Mai", style: style);
      break;
    case 5:
      text = const Text("Jui", style: style);
      break;
    case 6:
      text = const Text("Juil", style: style);
      break;
    case 7:
      text = const Text("Aou", style: style);
      break;
    case 8:
      text = const Text("Sep", style: style);
      break;
    case 9:
      text = const Text("Oct", style: style);
      break;
    case 10:
      text = const Text("Nov", style: style);
      break;
    case 11:
      text = const Text("Dec", style: style);
      break;
  }
  return SideTitleWidget(axisSide: t.axisSide, child: text);
}

class Bar {
  final int x;
  final double y;

  Bar({required this.x, required this.y});
}

class BarData {
  final double lun;
  final double mar;
  final double mer;
  final double jeu;
  final double ven;
  final double sam;
  final double dim;

  BarData(
      {required this.lun,
      required this.mar,
      required this.mer,
      required this.jeu,
      required this.ven,
      required this.sam,
      required this.dim});

  List<Bar> barData = [];

  void init() {
    barData = [
      Bar(x: 0, y: lun),
      Bar(x: 1, y: mar),
      Bar(x: 2, y: mer),
      Bar(x: 3, y: jeu),
      Bar(x: 4, y: ven),
      Bar(x: 5, y: sam),
      Bar(x: 6, y: dim)
    ];
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.asset, {
    required this.size,
    //required this.borderColor,
  });
  final String asset;
  final double size;
  //final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(2, 2),
            blurRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .20),
      child: Center(
        child: Image.asset(asset),
      ),
    );
  }
}
