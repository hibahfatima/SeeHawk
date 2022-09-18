import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'data/eye_point.dart';
import 'models/data_model.dart';

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

class StartReading extends StatefulWidget {
  final List<EyePoint> points;

  const StartReading(this.points, {Key? key}) : super(key: key);

  @override
  State<StartReading> createState() => _StartReadingState();
}

class _StartReadingState extends State<StartReading> {
  static List<Data> DataList = [Data(0, 0, 0, 0, 0, 0, 0, 0)];
  static List<FlSpot> readSpeedList = [];
  static List<FlSpot> attentionSpanList = [];
  static List<FlSpot> timePerPageList = [];
  final Stream<List<Data>> _datas = (() {
    late final StreamController<List<Data>> controller;
    controller = StreamController<List<Data>>(
      onListen: () async {
        controller.add(DataList);
        var url = Uri.parse('http://localhost:8000/tracker_data.txt');
        while (true) {
          await Future<void>.delayed(const Duration(milliseconds: 500 ));
          try {
            var response = await http.get(url);
            var data = response.body;
            LineSplitter ls = LineSplitter();
            List<String> _datas = ls.convert(data);
            final bundle = Data(double.parse(_datas[0]), double.parse(_datas[1]), int.parse(_datas[2]), 
                                double.parse(_datas[3]), double.parse(_datas[4]), int.parse(_datas[5]), 
                                int.parse(_datas[6]), double.parse(_datas[7]));

            readSpeedList.add(FlSpot(bundle.timePassed, bundle.readingSpeed));
            attentionSpanList.add(FlSpot(bundle.timePassed, bundle.attentionSpan));
            timePerPageList.add(FlSpot(bundle.timePassed, bundle.pagesRead / (bundle.timePassed + 1)));

            DataList.add(bundle);
            controller.add(DataList);
            debugPrint('${bundle.x} ${bundle.y}');
          } catch (e) {
            debugPrint('Error: $e');
          }
        }
        await controller.close();
      }
    );
    return controller.stream;
  })();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 0,
      ),
      body: StreamBuilder<List<Data>>(
        stream: _datas,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('its messed');
          } else {
            return Container(
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
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
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
                              spots: readSpeedList,
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
                      'Attention Span Ratio 🥴',
                      style: GoogleFonts.share(
                        fontSize: 28.0,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                    child: SizedBox(
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
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
                              spots: attentionSpanList,
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
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
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
                              spots: timePerPageList,
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
                    'Blink Count: ${snapshot.data![snapshot.data!.length - 1].blinkCount}',
                    style: GoogleFonts.share(
                      fontSize: 28.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    'Pages Read: ${snapshot.data![snapshot.data!.length - 1].pagesRead}',
                    style: GoogleFonts.share(
                      fontSize: 28.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    'Zone-out Count: ${snapshot.data![snapshot.data!.length - 1].linesRead}',
                    style: GoogleFonts.share(
                      fontSize: 28.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ]
              )
            );
          }
        }
      ),
    );
  }
}