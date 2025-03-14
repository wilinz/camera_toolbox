# camera_toolbox

佳能相机控制APP

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 协议说明
### GPS
```plaintext
选择手机作为GBS设备
06 04 00 00 00 00 00 00  bluetoothGattCharacteristic00040002-0000-1000-0000-d8492fffa821

| 控制位04 | 南北纬度标志（S,N） | 纬度 | 东西经度标志（W,E） | 经度 | 固定 2b (+号) 填充位 | 4位海拔 | 4位时间戳 |
04 4e d7 94 b1 41 45 ec 14 e3 42 2b 01 80 30 43 59 28 d3 67  bluetoothGattCharacteristic00040002-0000-1000-0000-d8492fffa821
04 53 8a 8a 1c 42 57 a7 16 ec 42 2b 01 80 30 43 e5 56 d3 67  bluetoothGattCharacteristic00040002-0000-1000-0000-d8492fffa821
```