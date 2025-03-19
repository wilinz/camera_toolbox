import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../common/logger.dart';

const String _handshakeServiceUuid = "00010000-0000-1000-0000-d8492fffa821";
const String _handshakeStartCharUuid = "00010006-0000-1000-0000-d8492fffa821";
const String _handshakeFinishCharUuid = "0001000a-0000-1000-0000-d8492fffa821";
const String _handshakeConfirmCharUuid = "0001000b-0000-1000-0000-d8492fffa821";

// 设备类型枚举
enum DeviceType { ios, android, clicker }

extension DeviceTypeExtension on DeviceType {
  int get value {
    switch (this) {
      case DeviceType.ios:
        return 0x01;
      case DeviceType.android:
        return 0x02;
      case DeviceType.clicker:
        return 0x03;
    }
  }

  String get name {
    switch (this) {
      case DeviceType.ios:
        return 'iOS';
      case DeviceType.android:
        return 'Android';
      case DeviceType.clicker:
        return 'Clicker';
    }
  }
}

Future<void> performHandshake({
  required List<BluetoothService> services,
  required String deviceName,
  required List<int> deviceId,
  DeviceType deviceType = DeviceType.android, // 默认为 Android
}) async {
  if (deviceId.length != 16) {
    throw HandshakeException("deviceId length must be 16");
  }

  // 查找握手服务
  BluetoothService? handshakeService = services.firstWhereOrNull(
    (s) => s.uuid.toString().toLowerCase() == _handshakeServiceUuid,
  );
  if (handshakeService == null) {
    logger.d("握手服务未找到！");
    return;
  }

  // 查找握手相关特征值
  BluetoothCharacteristic? handshakeStartChar =
      handshakeService.characteristics.firstWhereOrNull(
    (c) => c.uuid.toString().toLowerCase() == _handshakeStartCharUuid,
  );
  BluetoothCharacteristic? handshakeFinishChar =
      handshakeService.characteristics.firstWhereOrNull(
    (c) => c.uuid.toString().toLowerCase() == _handshakeFinishCharUuid,
  );

  if (handshakeStartChar == null || handshakeFinishChar == null) {
    logger.d("握手相关的 characteristic 未找到！");
    return;
  }
  final completer = Completer();
  // 发送握手启动数据：0x01 + device name
  List<int> deviceNameBytes = deviceName.codeUnits;
  List<int> handshakeStartPayload = [0x01] + deviceNameBytes;
  await handshakeStartChar.write(handshakeStartPayload, withoutResponse: false);
  logger.d("发送握手启动数据：$handshakeStartPayload");

  // 开启通知并监听握手结果
  await handshakeStartChar.setNotifyValue(true);

  handshakeStartChar.lastValueStream.listen((value) async {
    if (value.isNotEmpty && value[0] == 0x02) {
      logger.d("收到握手确认（0x02）通知");

      // 发送设备 ID 数据
      List<int> payloadId = [0x03] + deviceId;
      await handshakeFinishChar.write(payloadId, withoutResponse: false);
      logger.d("发送设备 ID 数据：$payloadId");

      // 发送设备名称数据
      List<int> payloadName = [0x04] + deviceNameBytes;
      await handshakeFinishChar.write(payloadName, withoutResponse: false);
      logger.d("发送设备名称数据：$payloadName");

      // 发送设备类型数据
      List<int> payloadType = [0x05, deviceType.value];
      await handshakeFinishChar.write(payloadType, withoutResponse: false);
      logger.d("发送设备类型数据：$payloadType");

      // 发送握手结束标识
      List<int> finishPayload = [0x01];
      await handshakeFinishChar.write(finishPayload, withoutResponse: false);
      logger.d("发送握手结束标识：$finishPayload");
      // completer.complete();
    } else {
      logger.d("收到握手通知：$value");
      completer.complete();
    }
  });

  await completer.future;
}
