import '../connectable_device.dart';

class BluetoothConnectivityState {
  List<ConnectableDevice> devices;
  bool isPermissionGranted;
  bool isDeviceConnected;
  bool isScanning;
  String errorMessage;
  String successMessage;
  String connectedDeviceName;
  String myOwnDevice;
  bool? isConnecting;
  bool isBluetoothOn;
  bool isSendingData;
  bool isResettingData;
  String connectingDeviceAddress;

  BluetoothConnectivityState(
      {required this.devices,
      required this.isDeviceConnected,
      required this.errorMessage,
      required this.successMessage,
      required this.isPermissionGranted,
      required this.connectedDeviceName,
      required this.myOwnDevice,
      required this.isScanning,
      required this.isConnecting,
      required this.isBluetoothOn,
      required this.isSendingData,
      required this.connectingDeviceAddress,
      required this.isResettingData});

  BluetoothConnectivityState copyWith({
    List<ConnectableDevice>? devices,
    bool? isPermissionGranted,
    String? errorMessage,
    String? successMessage,
    bool? isDeviceConnected,
    bool? isScanning,
    String? connectedDeviceName,
    String? myOwnDevice,
    bool? isConnecting,
    bool? isBluetoothOn,
    bool? isSendingData,
    bool? isResettingData,
    String? connectingDeviceAddress, // Allow updating this field
  }) {
    return BluetoothConnectivityState(
        devices: devices ?? this.devices,
        isDeviceConnected: isDeviceConnected ?? this.isDeviceConnected,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
        connectedDeviceName: connectedDeviceName ?? this.connectedDeviceName,
        myOwnDevice: myOwnDevice ?? this.myOwnDevice,
        isScanning: isScanning ?? this.isScanning,
        isConnecting: isConnecting ?? this.isConnecting,
        isBluetoothOn: isBluetoothOn ?? this.isBluetoothOn,
        isSendingData: isSendingData ?? this.isSendingData,
        connectingDeviceAddress:
            connectingDeviceAddress ?? this.connectingDeviceAddress,
        isResettingData: isResettingData ?? this.isResettingData);
  }

  List<ConnectableDevice> getAvailableDevices() {
    return devices.where((device) => !device.isConnected).toList();
  }

// Method to get connected devices
  List<ConnectableDevice> getConnectedDevices() {
    return devices.where((device) => device.isConnected).toList();
  }
}
