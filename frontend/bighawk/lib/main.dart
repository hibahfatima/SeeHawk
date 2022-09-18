import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'data/eye_point.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Share',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 0,
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 0, 35, 65),
                Color.fromARGB(255, 58, 0, 70),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(50.0)
              ),
              const Image(
                height: 170,
                image: NetworkImage('https://i.imgur.com/eG40PbD.png')
              ),
              const Padding(padding: EdgeInsets.all(5.0),),
              Center(
                child: Text(
                  'SEE HAWK',
                  style: GoogleFonts.share(
                    fontSize: 40.0,
                    color: const Color(0xFFDD4C4C),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(80.0),),
              Center(
                child: Text(
                  'Welcome! What would you like to do?',
                  style: GoogleFonts.share(
                    fontSize: 20.0,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                )
              ),
              const Padding(
                padding: EdgeInsets.all(8.0)
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFDD4C4C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: Text('Start Reading',
                  style: GoogleFonts.share(
                      fontSize: 32.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0)
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFDD4C4C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                  onPressed: () {},
                  child: Text('View Stats',
                  style: GoogleFonts.share(
                      fontSize: 32.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0)
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFDD4C4C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                  onPressed: () {},
                  child: Text('About',
                  style: GoogleFonts.share(
                      fontSize: 32.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}

Route _createRoute() {
  List<EyePoint>? points = [EyePoint(1.0, 1.0), EyePoint(2.0, 2.0)];
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => StartReading(points),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

final List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

class StartReading extends StatelessWidget {
  final List<EyePoint> points;  

  const StartReading(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color.fromARGB(255, 0, 35, 65),
              Color.fromARGB(255, 58, 0, 70),
            ]
          )
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0)
            ),
            Center(
              child: Text(
                'Average Reading Speed 🏃',
                style: GoogleFonts.share(
                  fontSize: 28.0,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
              child: SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    titlesData: FlTitlesData(
                      show: false
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [  
                            Color.fromARGB(255, 0, 208, 152),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        barWidth: 5,
                        // dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color.fromARGB(255, 35, 182, 230),
                              Color.fromARGB(255, 2, 209, 154),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Average Zone-out Time 🥴',
                style: GoogleFonts.share(
                  fontSize: 28.0,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
              child: SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    titlesData: FlTitlesData(
                      show: false
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [  
                            Color.fromARGB(255, 0, 208, 152),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        barWidth: 5,
                        // dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color.fromARGB(255, 35, 182, 230),
                              Color.fromARGB(255, 2, 209, 154),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Average Time Per Page 🧠',
                style: GoogleFonts.share(
                  fontSize: 28.0,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
              child: SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    titlesData: FlTitlesData(
                      show: false
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [  
                            Color.fromARGB(255, 0, 208, 152),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        barWidth: 5,
                        // dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color.fromARGB(255, 35, 182, 230),
                              Color.fromARGB(255, 2, 209, 154),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              'Lines Read: 28',
              style: GoogleFonts.share(
                fontSize: 28.0,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Pages Read: 28',
              style: GoogleFonts.share(
                fontSize: 28.0,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Zone-out Count: 28',
              style: GoogleFonts.share(
                fontSize: 28.0,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ]
        )
      ),
    );
  }
}