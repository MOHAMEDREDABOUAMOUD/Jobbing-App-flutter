// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class AppStatistics extends StatefulWidget {
  const AppStatistics({Key? key}) : super(key: key);

  @override
  State<AppStatistics> createState() => _AppStatisticsState();
}

class _AppStatisticsState extends State<AppStatistics> {
  int touchedIndex = 0;
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
                      SizedBox(height: 20),
                      Text(
                        "En quelques chiffres",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24)),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "10000",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: "\nPrestataires",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 23,
                                )),
                          ]),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24)),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "60000",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text:
                                    "\nClients ont fait appel à Smart Jobbing",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 23,
                                )),
                          ]),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24)),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "1 555 000",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: "\nServices rendus depuis la création",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 23,
                                )),
                          ]),
                        ),
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
            value: 10,
            title: '10%',
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
            value: 25,
            title: '25%',
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
            value: 5,
            title: '5%',
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
            value: 10,
            title: '10%',
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
            value: 5,
            title: '5%',
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
            value: 10,
            title: '10%',
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
            value: 5,
            title: '5%',
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
            value: 3,
            title: '3%',
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
