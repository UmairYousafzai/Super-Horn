import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/core/theme/colors.dart';
import 'package:superhorn/domain/entities/connectable_device.dart';

import '../../providers/bluetooth_devices_provider.dart';
import '../../providers/bluetooth_provider.dart';

class BluetoothDeviceItemWidget extends ConsumerStatefulWidget {
  final ConnectableDevice device;

  const BluetoothDeviceItemWidget({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BluetoothDeviceItemWidgetState();
  }
}

class BluetoothDeviceItemWidgetState
    extends ConsumerState<BluetoothDeviceItemWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothDevicesStateProvider);
    final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: () {
          stateNotifier.setConnecting(!state.isConnecting);

          ref
              .read(bluetoothNotifierProvider.notifier)
              .connectToDevice(widget.device);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                widget.device.deviceName.toString(),
                maxLines: 18,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AColors.primaryColor),
              ),
            ),
            if (widget.device.isConnected)
              Container(
                width: 30,
                height: 20,
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
            if (widget.device.isConnecting)
              CircularProgressIndicator(
                color: AColors.primaryColor,
                strokeWidth: 1,
              )
          ],
        ),
      ),
    );
  }
}
