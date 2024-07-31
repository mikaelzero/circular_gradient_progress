import 'package:circular_gradient_progress/circular_gradient_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  runApp(const MainApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const PaintApp(),
    );
  }
}

class PaintApp extends StatefulWidget {
  const PaintApp({super.key});

  @override
  State<PaintApp> createState() => _PaintAppState();
}

class _PaintAppState extends State<PaintApp> {
  @override
  Widget build(BuildContext context) {
    final backgroundColors = [
      const Color(0xffE00213).withOpacity(0.22),
      const Color(0xff3BDD00).withOpacity(0.22),
      const Color(0xff02BBE1).withOpacity(0.22),
    ];
    const gradientColors = [
      [Color(0xffE00213), Color.fromARGB(255, 245, 62, 138)],
      [Color(0xff3BDD00), Color(0xffB6FE02)],
      [Color(0xff02BBE1), Color(0xff00FCD0)],
    ];
    const duration = Duration(seconds: 3);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    sweepAngles: const [-1, -1, -1],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    sweepAngles: const [30, 70, 100, 300, 20, 10, 10],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    sweepAngles: const [600, 720, 860],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    sweepAngles: const [600, 720, 860],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    sweepAngles: const [300, 120, 260],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    sweepAngles: const [330, 330, 330],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.3,
                    gapRatio: 0.2,
                    sweepAngles: const [400, 500, 600],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.6,
                    gapRatio: 0.2,
                    sweepAngles: const [400, 500, 600],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0.2,
                    gapRatio: 0,
                    sweepAngles: const [400, 500, 600],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                  CircularGradientCombineWidget(
                    size: 120,
                    duration: duration,
                    centerCircleSizeRatio: 0,
                    gapRatio: 0,
                    sweepAngles: const [400, 500, 600],
                    backgroundColors: backgroundColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
