import 'package:get/get.dart';
import 'package:health/health.dart';

class PermissionController extends GetxController {
  final _health = Health();

  // Permission states
  var stepsPermission = false.obs;
  var heartRatePermission = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var stepErrorMessage = ''.obs;
  var heartRateErrorMessage = ''.obs;

  bool get allPermissionsGranted => stepsPermission.value && heartRatePermission.value;

  @override
  void onInit() {
    super.onInit();
    checkAllPermissions();
  }

  // Check all permissions
  Future<void> checkAllPermissions() async {
    await checkStepsPermission();
    await checkHeartRatePermission();
  }

  // Steps-specific permission check
  Future<void> checkStepsPermission() async {
    try {
      if (stepsPermission.value) {
        // If permission is already granted, revoke it
        stepsPermission.value = false;
        return;
      }
      
      final types = [HealthDataType.STEPS];
      final granted = await _health.requestAuthorization(types);
      if (granted) {
        stepsPermission.value = true;
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);
        
        final steps = await _health.getTotalStepsInInterval(midnight, now);
        print('Steps count: $steps'); // You can replace this with your own logic
      }
    } catch (e) {
      print('Error requesting steps permission: $e');
      stepsPermission.value = false;
    }
  }

  // Heart rate-specific permission check
  Future<void> checkHeartRatePermission() async {
    try {
      if (heartRatePermission.value) {
        // If permission is already granted, revoke it
        heartRatePermission.value = false;
        return;
      }

      final types = [HealthDataType.HEART_RATE];
      final granted = await _health.requestAuthorization(types);
      if (granted) {
        heartRatePermission.value = true;
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day);
        
      final results = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.HEART_RATE]
      );
      print('Heart rate readings: ${results.length}'); // You can replace this with your own logic
      }
    } catch (e) {
      print('Error requesting heart rate permission: $e');
      heartRatePermission.value = false;
    }
  }

  // Request steps permission specifically
  Future<void> requestStepsPermission() async {
    try {
      isLoading.value = true;
      stepErrorMessage.value = '';

      final types = [HealthDataType.STEPS];

      final requested = await _health.requestAuthorization(types);
      stepsPermission.value = requested;

      if (!requested) {
        stepErrorMessage.value = 'Steps permission denied. Please grant access in settings.';
      }
    } catch (e) {
      stepErrorMessage.value = 'Error requesting steps permission: ${e.toString()}';
      stepsPermission.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Request heart rate permission specifically
  Future<void> requestHeartRatePermission() async {
    try {
      isLoading.value = true;
      heartRateErrorMessage.value = '';

      final types = [HealthDataType.HEART_RATE];
      final requested = await _health.requestAuthorization(types);
      heartRatePermission.value = requested;

      if (!requested) {
        heartRateErrorMessage.value = 'Heart rate permission denied. Please grant access in settings.';
      }
    } catch (e) {
      heartRateErrorMessage.value = 'Error requesting heart rate permission: ${e.toString()}';
      heartRatePermission.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Request all permissions at once
  Future<void> requestAllPermissions() async {
    await requestStepsPermission();
    await requestHeartRatePermission();
  }

  // Fetch steps data (only if permission granted)
  Future<void> fetchStepsData() async {
    if (!stepsPermission.value) {
      stepErrorMessage.value = 'Steps permission not granted';
      return;
    }
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(midnight, now);
      print('Steps today: $steps'); // You can replace this with your own logic
    } catch (e) {
      stepErrorMessage.value = 'Error fetching steps: ${e.toString()}';
    }
  }

  // Fetch heart rate data (only if permission granted)
  Future<void> fetchHeartRateData() async {
    if (!heartRatePermission.value) {
      heartRateErrorMessage.value = 'Heart rate permission not granted';
      return;
    }
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final results = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.HEART_RATE]
      );
      print('Heart rate readings: ${results.length}'); // You can replace this with your own logic
    } catch (e) {
      heartRateErrorMessage.value = 'Error fetching heart rate: ${e.toString()}';
    }
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
