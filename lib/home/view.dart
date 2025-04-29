import 'package:ampi/battery/service.dart';
import 'package:ampi/line-chart/model.dart';
import 'package:ampi/line-chart/view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final historyAmp = <int>[];

  final BatteryService batteryService = BatteryService();

  @override
  void initState() {
    super.initState();
    batteryService.startMonitoring(
      onChangeAmp: (value) {
        setState(() {
          historyAmp.add(value);
        });
      },
    );
  }

  @override
  void dispose() {
    batteryService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currentInMilliAmps = (historyAmp.lastOrNull ?? 0) / 1000;
    final data = [
      Chart(x: 0, y: 100),
      Chart(x: 1, y: 1),
      Chart(x: 2, y: 2),
      Chart(x: 3, y: 33),
      Chart(x: 4, y: 444),
      Chart(x: 5, y: 110),
      Chart(x: 6, y: 32),
      Chart(x: 7, y: 212),
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Battery Current Draw")),
      body: Column(
        children: [
          Text(
            'Current Now: ${currentInMilliAmps.toStringAsFixed(2)} mA',
            style: TextStyle(fontSize: 24),
          ),

          LineChartView(data: data),
        ],
      ),
    );
  }
}
