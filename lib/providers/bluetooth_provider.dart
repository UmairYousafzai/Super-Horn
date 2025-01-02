import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superhorn/domain/entities/connectable_device.dart';
import 'package:superhorn/domain/entities/states/bluetooth_connectivity_state.dart';

import '../core/utils/services/bluetooth_service.dart';

class BluetoothNotifier extends StateNotifier<BluetoothConnectivityState> {
  BluetoothNotifier(this._service)
      : super(BluetoothConnectivityState(
            devices: [],
            isPermissionGranted: false,
            isDeviceConnected: false,
            isScanning: false,
            errorMessage: "",
            successMessage: "",
            connectedDeviceName: "",
            myOwnDevice: "",
            isConnecting: false,
            isBluetoothOn: false,
            isSendingData: false,
            isResettingData: false,
            isAnimating: false,
            connectingDeviceAddress: ''));

  final FlutterBluetoothSerial bluetoothSerial =
      FlutterBluetoothSerial.instance;
  final BluetoothServiceClass _service;

  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      state = state.copyWith(isPermissionGranted: true);
      if (kDebugMode) {
        print("All required permissions granted.");
      }
    } else {
      var statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (statuses.values.any((status) => !status.isGranted)) {
        // Navigate to app settings directly
        await openAppSettings();
      }
    }
  }

  void getDeviceName() async {
    String bluetoothName = "";
    try {
      String? name = await FlutterBluetoothSerial.instance.name;
      bluetoothName = name ?? "Unknown Bluetooth Name";
      if (kDebugMode) {
        print("device name=>>>>>>>>> $bluetoothName");
      }
    } catch (e) {
      bluetoothName = "Failed to fetch Bluetooth name: $e";
    }
    state = state.copyWith(myOwnDevice: bluetoothName);
  }

  /// Start scanning for Bluetooth devices
  void scanForDevices() async {
    await requestPermissions();

    isBlueToothTurnOn((isOn) {
      if (isOn) {
        state = state.copyWith(isBluetoothOn: true, isScanning: true);
        bluetoothSerial
            .startDiscovery()
            .listen((BluetoothDiscoveryResult result) {
          final existingDevices = state.devices;
          final device = result.device;

          // Avoid duplicates
          if (!existingDevices.any((d) => d.deviceAddress == device.address)) {
            if (device.name != null && device.name != "null") {
              ConnectableDevice connectableDevice = ConnectableDevice(
                  deviceName: device.name,
                  deviceAddress: device.address,
                  isConnecting: false,
                  isConnected: device.isConnected);
              print("connectable device ====> ${connectableDevice.deviceName}");
              state = state
                  .copyWith(devices: [...existingDevices, connectableDevice]);
            }
          }

          if (kDebugMode) {
            print("Discovered device: ${device.name} (${device.address})");
          }
        }).onDone(() {
          state = state.copyWith(isScanning: false);
          if (kDebugMode) {
            print("Discovery complete.");
          }
        });
      } else {
        setError("Bluetooth is off");
      }
    });
  }

  Future<void> stopScanning() async {
    try {
      // Cancel the ongoing discovery process
      await bluetoothSerial.cancelDiscovery();
      resetState(); // Reset the state of the notifier

      // Turn off Bluetooth
      bool? isDisabled = await bluetoothSerial.requestDisable();
      if (isDisabled == true) {
        state = state.copyWith(isBluetoothOn: false);
        if (kDebugMode) {
          print("Bluetooth has been turned off.");
        }
      } else {
        if (kDebugMode) {
          print("Failed to turn off Bluetooth.");
        }
      }

      // Check Android version and navigate to Bluetooth settings if needed
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        // Debug: Check what Android version you are getting
        if (kDebugMode) {
          print("Android SDK version: ${androidInfo.version.sdkInt}");
        }

        // If Android version is greater than 12, navigate to Bluetooth settings
        if (androidInfo.version.sdkInt > 31) {
          openBluetoothSettings();
        } else {
          // For Android 12 or lower, disable Bluetooth
          bool? isDisabled = await bluetoothSerial.requestDisable();
          if (isDisabled == true) {
            state = state.copyWith(isBluetoothOn: false);
            if (kDebugMode) {
              print("Bluetooth has been turned off (Android 12 or lower).");
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error stopping scanning or disabling Bluetooth: $e");
      }
    }
  }

  Future<void> openBluetoothSettings() async {
    try {
      // Create an Intent to open Bluetooth settings
      final intent = AndroidIntent(
        action: 'android.settings.BLUETOOTH_SETTINGS',
        package: 'com.android.settings',
      );

      // Launch the intent
      await intent.launch();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to open Bluetooth settings: $e");
      }
    }
  }

  Future<void> connectToDevice(ConnectableDevice device) async {
    state = state.copyWith(
        isConnecting: true, connectingDeviceAddress: device.deviceAddress);

    await disconnectDevice(device);
    try {
      await _service.connectToDevice(device, (flag) {
        if (flag) {
          state = state.copyWith(
            isDeviceConnected: true,
            connectedDeviceName: device.deviceName,
            devices: state.devices
                .where((d) => d.deviceAddress != device.deviceAddress)
                .toList(), // Remove the connected device from the list
          );
        } else {
          setError("Connection Failed");
        }
      });
    } catch (e) {
      setError("Connection Failed");

      if (kDebugMode) {
        print(
            "Error connecting to device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
    } finally {
      state = state.copyWith(isConnecting: false);
    }
  }

  Future<void> disconnectDevice(ConnectableDevice device) async {
    // flutter_bluetooth_serial does not keep a direct connection list, so manage manually
    try {
      // Close connections if you manage them in `_service`
      await _service.disconnectDevice(device);
      if (kDebugMode) {
        print('Disconnected from the device: ${device.deviceName}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error disconnecting from device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
    }
  }

  Future<void> sendData(String data) async {
    setAnimating(false);
    setSendingData(true);
    if (kDebugMode) {
      print("Sending data: $data, isSendingData: ${state.isSendingData}");
    } // Debug log
    await Future.delayed(const Duration(seconds: 2));

    _service.sendData(data, (flag) {
      if (flag) {
        setSuccess("Sent");
      } else {
        setError("Data not sent");
      }
    });
    setSendingData(false);
    setAnimating(true);
    // Debug log
  }

  Future<void> resetData(String data) async {
    setResettingData(true);
    if (kDebugMode) {
      print("Sending data: $data, isSendingData: ${state.isResettingData}");
    } // Debug log
    await Future.delayed(const Duration(seconds: 2));

    _service.sendData(data, (flag) {
      if (flag) {
        setSuccess("Sent");
      } else {
        setError("Data not sent");
      }
    });
    setResettingData(false);
    // Debug log
  }

  void isBlueToothTurnOn(void Function(bool) statusCallBack) {
    _service.ensureBluetoothIsOn((message) {
      statusCallBack(message);
    });
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  void setSuccess(String message) {
    state = state.copyWith(successMessage: message);
  }

  void setScanning(bool isScanning) {
    state = state.copyWith(
      isScanning: isScanning,
    );
  }

  void setBluetoothOn(bool isBluetoothOn) {
    state = state.copyWith(
      isBluetoothOn: isBluetoothOn,
    );
  }

  void setConnecting(bool isConnecting) {
    state = state.copyWith(isConnecting: isConnecting);
  }

  void setSendingData(bool isSendingData) {
    state = state.copyWith(isSendingData: isSendingData);
  }

  void setResettingData(bool isResetting) {
    state = state.copyWith(isResettingData: isResetting);
  }

  void setAnimating(bool isAnimating) {
    state = state.copyWith(isAnimating: isAnimating);
  }

  void resetState() {
    state = BluetoothConnectivityState(
        devices: [],
        isDeviceConnected: false,
        errorMessage: "",
        successMessage: "",
        isPermissionGranted: false,
        connectedDeviceName: "",
        myOwnDevice: "",
        isConnecting: false,
        isScanning: false,
        isBluetoothOn: false,
        isSendingData: false,
        isResettingData: false,
        isAnimating: false,
        connectingDeviceAddress: '');
  }
}

final bluetoothNotifierProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothConnectivityState>((ref) {
  final service = ref.read(bluetoothServiceProvider);
  return BluetoothNotifier(service);
});
