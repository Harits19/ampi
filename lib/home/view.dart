import 'dart:math';

import 'package:ampi/battery/service.dart';
import 'package:ampi/home/model.dart';
import 'package:ampi/line-chart/model.dart';
import 'package:ampi/line-chart/view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final historyAmp = <HistoryAmpereModel>[];

  final BatteryService batteryService = BatteryService();

  final double milliAmp = 1000;

  @override
  void initState() {
    super.initState();
    batteryService.startMonitoring(
      onChangeAmp: (value) {
        setState(() {
          historyAmp.add(
            HistoryAmpereModel(
              value: Random().nextInt(900) * milliAmp,
              time: DateTime.now(),
            ),
          );
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
    double currentInMilliAmps = (historyAmp.lastOrNull?.value ?? 0) / milliAmp;
    return Scaffold(
      appBar: AppBar(title: Text("Battery Current Draw")),
      body: Column(
        children: [
          Text(
            'Current Now: ${currentInMilliAmps.toStringAsFixed(2)} mA',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          LineChartView(
            data: historyAmp,
            yValue: (item) => item.value.toDouble(),
            xString: (item) => item.time.second.toString(),
            yString: (item) => (item.value / milliAmp).toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
