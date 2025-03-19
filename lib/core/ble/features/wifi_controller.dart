import 'package:camera_toolbox/core/ble/features/ble_features.dart';
import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEWiFiController extends BLEFeature {
  static const String wifiServiceUUID = "00020000-0000-1000-0000-d8492fffa821";

  static const String wifiUnknownCharUUID = "00020001-0000-1000-0000-d8492fffa821";
  static const String wifiInitCharUUID = "00020002-0000-1000-0000-d8492fffa821";
  static const String wifiInitResultCharUUID = "00020003-0000-1000-0000-d8492fffa821";
  static const String wifiSSIDCharUUID = "00020004-0000-1000-0000-d8492fffa821";
  static const String wifiUnknownChar2UUID = "00020005-0000-1000-0000-d8492fffa821";
  static const String wifiPasswordCharUUID = "00020006-0000-1000-0000-d8492fffa821";

  BLEWiFiController({required super.device});

  Future<void> setupWiFiAP({required String ssid, required String password}) async {
    final services = await device.discoverServices();
    BluetoothService? wifiService = services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == wifiServiceUUID,
    );
    if (wifiService == null) {
      throw Exception("Wi-Fi 服务未找到！");
    }

    final wifiInitChar = _findChar(wifiService, wifiInitCharUUID);
    final wifiSSIDChar = _findChar(wifiService, wifiSSIDCharUUID);
    final wifiPasswordChar = _findChar(wifiService, wifiPasswordCharUUID);
    final wifiInitResultChar = _findChar(wifiService, wifiInitResultCharUUID);

    try {
      await wifiInitChar.write([0x0A], withoutResponse: false);
      print("发送 Wi-Fi 初始化命令");

      List<int> ssidBytes = ssid.codeUnits;
      if (ssidBytes.length > 32) {
        throw Exception("SSID 不能超过32字节");
      }
      await wifiSSIDChar.write(ssidBytes, withoutResponse: false);
      print("写入 Wi-Fi SSID: $ssid");

      List<int> passwordBytes = password.codeUnits;
      if (passwordBytes.length != 8) {
        throw Exception("密码必须为8位数字");
      }
      await wifiPasswordChar.write(passwordBytes, withoutResponse: false);
      print("写入 Wi-Fi 密码: $password");

      await wifiInitChar.write([0x01], withoutResponse: false);
      print("发送启动 Wi-Fi AP 命令");

      await wifiInitResultChar.setNotifyValue(true);
      wifiInitResultChar.onValueReceived.listen((value) {
        print("Wi-Fi AP 启动结果通知: $value");
        if (value.length >= 2 && value[0] == 0x01 && value[1] == 0x03) {
          print("Wi-Fi AP 启动成功");
        } else {
          print("Wi-Fi AP 启动失败或状态未知");
        }
      });
    } catch (e) {
      print("Wi-Fi AP 配置过程中出现异常：$e");
    }
  }

  Future<void> stopWiFiAP() async {
    final services = await device.discoverServices();
    BluetoothService? wifiService = services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == wifiServiceUUID,
    );
    if (wifiService == null) {
      throw Exception("Wi-Fi 服务未找到！");
    }

    final wifiInitChar = _findChar(wifiService, wifiInitCharUUID);

    try {
      // 根据一般 BLE 设计，通常关闭 AP 可能是写入 0x00，具体看协议，这里假设是 0x00
      await wifiInitChar.write([0x00], withoutResponse: false);
      print("发送停止 Wi-Fi AP 命令");

      // 有些设备可能会有关闭确认通知，这里监听一下
      await wifiInitChar.setNotifyValue(true);
      wifiInitChar.onValueReceived.listen((value) {
        print("Wi-Fi AP 停止结果通知: $value");
      });
    } catch (e) {
      print("停止 Wi-Fi AP 过程中出现异常：$e");
    }
  }

  Future<void> readWiFiInfo() async {
    final services = await device.discoverServices();
    BluetoothService? wifiService = services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == wifiServiceUUID,
    );
    if (wifiService == null) {
      throw Exception("Wi-Fi 服务未找到！");
    }

    final unknownChar = _findChar(wifiService, wifiUnknownCharUUID);
    final ssidChar = _findChar(wifiService, wifiSSIDCharUUID);
    final unknownChar2 = _findChar(wifiService, wifiUnknownChar2UUID);
    final passwordChar = _findChar(wifiService, wifiPasswordCharUUID);

    try {
      var unknown1 = await unknownChar.read();
      print("未知特征1 (0xf202) 读取结果: $unknown1");

      var ssidBytes = await ssidChar.read();
      String ssid = String.fromCharCodes(ssidBytes).replaceAll('\u0000', '');
      print("Wi-Fi AP SSID: $ssid");

      var unknown2 = await unknownChar2.read();
      print("未知特征2 (0xf20c) 读取结果: $unknown2");

      var passwordBytes = await passwordChar.read();
      String password = String.fromCharCodes(passwordBytes);
      print("Wi-Fi AP 密码: $password");

      final wifiInitChar = _findChar(wifiService, wifiInitCharUUID);
      await wifiInitChar.setNotifyValue(true);
      wifiInitChar.onValueReceived.listen((value) {
        if (value.length >= 16) {
          var bssid = value.sublist(10, 16)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(':');
          print("Wi-Fi AP BSSID: $bssid");
        } else {
          print("BSSID 数据不足");
        }
      });

    } catch (e) {
      print("读取 Wi-Fi 信息时出现异常：$e");
    }
  }

  BluetoothCharacteristic _findChar(BluetoothService service, String charUUID) {
    BluetoothCharacteristic? char = service.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == charUUID,
    );
    if (char == null) {
      throw Exception("特征 $charUUID 未找到！");
    }
    return char;
  }
}
