import '../connectable_device.dart';

class BluetoothConnectivityState {
  List<ConnectableDevice> devices;
  bool isPermissionGranted;
  bool isDeviceConnected;
  String errorMessage;
  String successMessage;

  BluetoothConnectivityState(
      {required this.devices,
      required this.isDeviceConnected,
      required this.errorMessage,
      required this.successMessage,
      required this.isPermissionGranted});

  BluetoothConnectivityState copyWith(
      {List<ConnectableDevice>? devices,
      bool? isPermissionGranted,
      String? errorMessage,
      String? successMessage,
      bool? isDeviceConnected}) {
    return BluetoothConnectivityState(
        devices: devices ?? this.devices,
        isDeviceConnected: isDeviceConnected ?? this.isDeviceConnected,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted);
  }
}
