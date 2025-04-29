import 'dart:async';

import 'package:flutter/services.dart';

class BatteryService {
  static const platform = MethodChannel('com.example.battery/info');

  int currentAmp = 0;
  Timer? timer;

  void startMonitoring({required ValueChanged<int> onChangeAmp}) {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => getCurrentNow(onChangeAmp: onChangeAmp),
    );
  }

  Future<void> getCurrentNow({required ValueChanged<int> onChangeAmp}) async {
    try {
      final result = await platform.invokeMethod('getBatteryCurrentNow');
      onChangeAmp(result);
    } on PlatformException catch (e) {
      print("Failed to get battery current: '${e.message}'.");
    }
  }

  void dispose() {
    timer?.cancel();
  }
}
