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
    final data = [100, 222, 123, 233, 211, 10];
    return Scaffold(
      appBar: AppBar(title: Text("Battery Current Draw")),
      body: Column(
        children: [
          Text(
            'Current Now: ${currentInMilliAmps.toStringAsFixed(2)} mA',
            style: TextStyle(fontSize: 24),
          ),

          LineChartView(data: data, yValue: (value) => value.toDouble()),
        ],
      ),
    );
  }
}
