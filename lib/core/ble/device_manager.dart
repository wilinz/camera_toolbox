import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/utils/get_storage_utils.dart';
import 'package:camera_toolbox/utils/string.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_storage/get_storage.dart';

import 'device.dart';
import 'handshake.dart';

class BLEDeviceManager {
  static const String _savedDevicesKey = 'saved_ble_devices';

  static Future<BLEDeviceManager> get instance async {
    _instance ??= BLEDeviceManager._();
    _instance!._storage = await newAppSupportGetStorage();
    // await _instance!._autoReconnect();
    return _instance!;
  }

  BLEDeviceManager._();

  late GetStorage _storage;
  static BLEDeviceManager? _instance;

  final _connectedDevices = <BluetoothDevice>[];

  List<BluetoothDevice>? get connectedDevice => _connectedDevices;

  Future<BluetoothDevice> getConnectedDevice(String remoteId) async {
    final device = BluetoothDevice.fromId(remoteId);
    if (device.isDisconnected) {
      await connectToDevice(device);
    }
    return device;
  }

  /// 自动重连逻辑
  Future<void> _autoReconnect() async {
    List<dynamic> savedJsonList =
        _storage.read<List<dynamic>>(_savedDevicesKey) ?? [];
    if (savedJsonList.isEmpty) {
      logger.d("无已保存设备需要自动连接");
      return;
    }

    List<BLEDeviceDesc> savedDevices = savedJsonList
        .map((json) => BLEDeviceDesc.fromJson(json as Map<String, dynamic>))
        .toList();

    logger.d("检测到 ${savedDevices.length} 个已保存设备，尝试自动连接...");

    for (var savedDevice in savedDevices) {
      try {
        final device = BluetoothDevice.fromId(savedDevice.remoteId);
        logger.d("自动连接设备：${savedDevice.name} (${savedDevice.remoteId})");
        await connectToDevice(device, autoReconnect: true);
      } catch (e, st) {
        logger.e("自动连接设备 [${savedDevice.remoteId}] 失败",
            error: e, stackTrace: st);
      }
    }
  }


// 假设 device.connectionState 是一个 Stream<BluetoothConnectionState>
  Future<void> waitForConnection(BluetoothDevice device, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      await device.connectionState
          .firstWhere((state) => state == BluetoothConnectionState.connected)
          .timeout(timeout);
      print('连接成功');
    } on TimeoutException {
      print('连接超时');
      // 你可以选择抛出异常或返回
      // throw Exception('连接设备超时');
    }
  }


  /// 手动连接 & 保存设备
  Future<void> connectToDevice(BluetoothDevice device,
      {bool autoReconnect = false}) async {
    logger.d(
        "${autoReconnect ? "自动" : "手动"}尝试连接设备：${device.platformName.isNotEmpty ? device.platformName : '未知设备'} (${device.remoteId})");
    if (device.isDisconnected) {
      logger.d("正在重新连接");
      // await device.disconnect();
      await device.connect(autoConnect: true, mtu: null);

      await waitForConnection(device);
      // device.connectionState.listen((it){
      //   logger.d("connectionState: $it");
      // });

      if (!kIsWeb && Platform.isAndroid) {
        await device.requestMtu(512);
      }
    }

    final services = await device.discoverServices();
    String deviceName = await getDeviceName();

    await performHandshake(
      services: services,
      deviceName: deviceName,
      deviceId: utf8.encode(
        generateRandomString(16),
      ),
      // deviceType: (Platform.isIOS || Platform.isMacOS) ? DeviceType.ios : DeviceType.android,
    );
    _connectedDevices.add(device);
    _saveDevice(device);
    logger.d("连接成功，发现 ${services.length} 个服务");
  }

  /// 保存设备（自定义类型）
  void _saveDevice(BluetoothDevice device) {
    List<dynamic> savedJsonList =
        _storage.read<List<dynamic>>(_savedDevicesKey) ?? [];

    List<BLEDeviceDesc> savedDevices = savedJsonList
        .map((json) => BLEDeviceDesc.fromJson(json as Map<String, dynamic>))
        .toList();

    bool alreadyExists =
        savedDevices.any((d) => d.remoteId == device.remoteId.str);

    if (!alreadyExists) {
      savedDevices.add(BLEDeviceDesc(
        name: device.platformName.isNotEmpty ? device.platformName : "未知设备",
        remoteId: device.remoteId.str,
      ));
      _storage.write(
          _savedDevicesKey, savedDevices.map((e) => e.toJson()).toList());
      _storage.save();
      logger.d("已保存设备: ${device.platformName} (${device.remoteId.str})");
    } else {
      logger.d("设备 ${device.remoteId.str} 已存在，无需重复保存");
    }
  }

  /// 获取所有保存的设备
  List<BLEDeviceDesc> getSavedDevices() {
    List<dynamic> savedJsonList =
        _storage.read<List<dynamic>>(_savedDevicesKey) ?? [];
    return savedJsonList
        .map((json) => BLEDeviceDesc.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 清空保存的设备
  Future<void> clearSavedDevices() async {
    await _storage.remove(_savedDevicesKey);
    logger.d("已清除所有保存的设备");
  }

  /// 获取当前设备名
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

  // 新增: 删除已保存设备
  Future<void> removeSavedDevice(String remoteId) async {
    // 获取当前保存的设备列表
    List<String> savedIds =
        (_storage.read<List<dynamic>>(_savedDevicesKey) ?? []).cast<String>();
    // 从列表中删除指定的设备
    savedIds.remove(remoteId);
    // 更新存储中的设备列表
    await _storage.write(_savedDevicesKey, savedIds);
  }
}
