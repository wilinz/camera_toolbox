import 'dart:io';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/utils/get_storage_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_storage/get_storage.dart';

import 'handshake.dart';

class BLEDeviceManager {
  static Future<BLEDeviceManager> get instance async {
    _instance ??= BLEDeviceManager._();
    _instance!._storage = await newAppSupportGetStorage();
    return _instance!;
  }

  BLEDeviceManager._();

  late GetStorage _storage;
  static BLEDeviceManager? _instance;

  final _connectedDevices = <BluetoothDevice>[];
  final _services = <String, List<BluetoothService>>{};

  List<BluetoothDevice>? get connectedDevice => _connectedDevices;

  Map<String, List<BluetoothService>> get services => _services;

  Future<List<BluetoothService>> disconnectDevice(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    _connectedDevices.add(device);
    _services[device.remoteId.str] = services;
    return services;
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    logger.d(
        "尝试连接设备：${device.platformName.isNotEmpty ? device.platformName : '未知设备'} (${device.remoteId})");
    try {
      await device.connect(autoConnect: true, mtu: null);
      await device.connectionState
          .firstWhere((state) => state == BluetoothConnectionState.connected);
      if (!kIsWeb && Platform.isAndroid) {
        await device.requestMtu(512);
      }
      final services = await disconnectDevice(device);
      logger.d("services: $services");

      String deviceName = await getDeviceName();

      await performHandshake(
          services: services,
          deviceName: deviceName,
          deviceId: "weyhrjmyurggikvb".codeUnits);
      logger.d("连接成功，发现 ${services.length} 个服务");
    } catch (e, st) {
      logger.e("连接异常：", error: e, stackTrace: st);
      logger.d("连接异常：$e");
    }
  }

  Future<String> getDeviceName() async {
    var deviceName = "";
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      deviceName = (await DeviceInfoPlugin().deviceInfo).data["model"];
    } else if (Platform.isWindows) {
      deviceName = (await DeviceInfoPlugin().windowsInfo).computerName;
    } else if (Platform.isLinux) {
      deviceName = (await DeviceInfoPlugin().linuxInfo).prettyName;
    }
    return deviceName;
  }

}
