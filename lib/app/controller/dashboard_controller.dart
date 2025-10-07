import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:health_connect/app/model/chart_data_model.dart';

class DashboardController extends GetxController {
  final stepsData = <ChartDataPoint>[].obs;
  final heartRateData = <ChartDataPoint>[].obs;
  final stepValue = ''.obs;
  final heartValue = ''.obs;
  final currentSteps = 0.0.obs; 
  final lastUpdate = DateTime.now().obs;
  Timer? _updateTimer;

  @override
  void onInit() {
    _generateMockData();
    _startLiveUpdates();
    super.onInit();
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }

  void _generateMockData() {
    final now = DateTime.now();
    final random = math.Random();

    // Generate 60 minutes of data (60 points, one per minute)
    stepsData.value = List.generate(60, (i) {
      final timestamp = now.subtract(Duration(minutes: 60 - i));
      final steps = (5000 + random.nextDouble() * 1000 - (60 - i) * 5).floorToDouble();
      return ChartDataPoint(timestamp, steps.clamp(4000, 6000));
    });

    heartRateData.value = List.generate(60, (i) {
      final timestamp = now.subtract(Duration(minutes: 60 - i)); // Same timestamps
      final heartRate = (65 + random.nextDouble() * 20 + math.sin((60 - i) / 10) * 10).floorToDouble();
      return ChartDataPoint(timestamp, heartRate.clamp(55, 95));
    });

    // Initialize stepValue and heartValue with latest values
    stepValue.value = stepsData.isNotEmpty ? stepsData.last.value.toStringAsFixed(0) : '0';
    heartValue.value = heartRateData.isNotEmpty ? '${heartRateData.last.value.toStringAsFixed(0)} bpm' : '0 bpm';
    currentSteps.value = stepsData.isNotEmpty ? stepsData.last.value : 5000;
  }

  void _startLiveUpdates() {
    _updateTimer?.cancel(); // Cancel any existing timer
    _updateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      final random = math.Random();
      final now = DateTime.now();

      // Update steps data
      final newSteps = currentSteps.value + random.nextInt(20).toDouble();
      stepsData.add(ChartDataPoint(now, newSteps.clamp(4000, 6000)));
      if (stepsData.length > 5) {
        stepsData.removeAt(0); // Keep last 60 points
      }
      currentSteps.value = newSteps;
      stepValue.value = newSteps.toStringAsFixed(0); // Update stepValue

      // Update heart rate data
      final newHeartRate = (65 + random.nextDouble() * 30).floorToDouble();
      heartRateData.add(ChartDataPoint(now, newHeartRate.clamp(65, 95)));
      if (heartRateData.length > 5) {
        heartRateData.removeAt(0); // Keep last 60 points
      }
      heartValue.value = '${newHeartRate.toStringAsFixed(0)} bpm'; // Update heartValue

      // Update last update time
      lastUpdate.value = now;

      // Notify listeners
      stepsData.refresh();
      heartRateData.refresh();
    });
  }

  // Optional: Implement getTimeSinceUpdate if needed for DashboardCard
  String getTimeSinceUpdate() {
    final seconds = (DateTime.now().millisecondsSinceEpoch - lastUpdate.value.millisecondsSinceEpoch) ~/ 1000;
    if (seconds < 60) return '${seconds}s ago';
    final minutes = seconds ~/ 60;
    return '${minutes}m ago';
  }
}