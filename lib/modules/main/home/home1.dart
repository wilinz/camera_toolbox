import 'dart:async';
import 'dart:typed_data';
import 'package:camera_toolbox/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Home1Page extends StatefulWidget {
  @override
  State createState() => _Home1PageState();
}

class _Home1PageState extends State<Home1Page> {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];
  String _log = '';
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  bool _isFirstLocationRequest = true; // 新增状态变量

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  // 检查并请求必要权限
  Future<void> _checkPermissions() async {
// 在_checkPermissions方法中添加位置权限请求
    Future<void> _checkPermissions() async {
      var statuses = await [
        Permission.locationWhenInUse,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      if (statuses[Permission.locationWhenInUse]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted) {
        _appendLog("权限检查完成");
      } else {
        _appendLog("位置或蓝牙权限不足，请检查设置！");
      }
    }
  }

  // 设置位置信息方法
  Future<void> _setLocation() async {
    if (_connectedDevice == null) {
      _appendLog("未连接设备，请先连接！");
      return;
    }

    // 获取蓝牙服务
    BluetoothService? locationService = _services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == "00040000-0000-1000-0000-d8492fffa821",
    );

    if (locationService == null) {
      _appendLog("位置服务未找到！");
      return;
    }

    // 获取特征
    BluetoothCharacteristic? locationChar = locationService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "00040002-0000-1000-0000-d8492fffa821",
    );

    if (locationChar == null) {
      _appendLog("位置特征未找到！");
      return;
    }

    try {
      // 首次发送需要初始化GBS设备选择
      if (_isFirstLocationRequest) {
        final initData = [0x06, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        await locationChar.write(initData, withoutResponse: false);
        _appendLog("已发送GBS设备选择命令：$initData");
        setState(() => _isFirstLocationRequest = false);
        await Future.delayed(Duration(milliseconds: 200)); // 等待设备响应
      }

      // 获取当前位置信息
      Position position = await Geolocator.getCurrentPosition();

      // 构造数据包
      var buffer = Uint8List(20);
      var byteData = ByteData.view(buffer.buffer);
      int offset = 0;

      // 控制位 (0x04)
      buffer[offset++] = 0x04;

      // 纬度信息
      buffer[offset++] = position.latitude >= 0 ? 0x4E : 0x53; // N/S
      byteData.setFloat32(offset, position.latitude.abs(), Endian.little);
      offset += 4;

      // 经度信息
      buffer[offset++] = position.longitude >= 0 ? 0x45 : 0x57; // E/W
      byteData.setFloat32(offset, position.longitude.abs(), Endian.little);
      offset += 4;

      // 固定填充位
      buffer[offset++] = 0x2B;

      // 海拔信息（转换为米）
      byteData.setFloat32(offset, 4000, Endian.little);
      offset += 4;

      // 时间戳（Unix时间戳秒）
      byteData.setUint32(
        offset,
        position.timestamp.millisecondsSinceEpoch ~/ 1000,
        Endian.little,
      );
      offset += 4;

      // 发送数据
      await locationChar.write(buffer, withoutResponse: false);
      _appendLog("位置信息发送成功：纬度${position.latitude} 经度${position.longitude}");
    } catch (e) {
      _appendLog("位置设置失败：$e");
      // 发生错误时重置初始化状态
      if (_isFirstLocationRequest == false) {
        setState(() => _isFirstLocationRequest = true);
      }
    }
  }

  // 日志追加方法
  void _appendLog(String message) {
    setState(() {
      _log += "$message\n";
    });
  }

  // 扫描设备并更新扫描结果列表
  Future<void> _startScan() async {
    _appendLog("开始扫描设备...");
    setState(() {
      _scanResults.clear();
      _isScanning = true;
    });

    // 检查蓝牙是否开启
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      toastFailure0("请先开启蓝牙");
      setState(() {
        _isScanning = false;
      });
      return;
    }

    try {
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 4),
        removeIfGone: Duration(seconds: 5),
        continuousUpdates: true,
      );
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });
    } catch (e) {
      _appendLog("扫描过程中出现异常：$e");
    }

    // 4秒后停止扫描
    Future.delayed(Duration(seconds: 4), () {
      FlutterBluePlus.stopScan();
      setState(() {
        _isScanning = false;
      });
      _appendLog("扫描结束");
    });
  }

  // 连接指定设备并发现服务
  Future<void> _connectToDevice(BluetoothDevice device) async {
    _appendLog("尝试连接设备：${device.name.isNotEmpty ? device.name : '未知设备'} (${device.id})");
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
      setState(() {
        _connectedDevice = device;
        _services = services;
      });
      _appendLog("连接成功，发现 ${services.length} 个服务");
    } catch (e) {
      _appendLog("连接异常：$e");
    }
  }

  // 执行握手流程
  Future<void> _performHandshake() async {
    if (_connectedDevice == null) {
      _appendLog("未连接设备，请先连接！");
      return;
    }

    BluetoothService? handshakeService = _services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == "00010000-0000-1000-0000-d8492fffa821",
    );
    if (handshakeService == null) {
      _appendLog("握手服务未找到！");
      return;
    }

    BluetoothCharacteristic? handshakeStartChar = handshakeService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "00010006-0000-1000-0000-d8492fffa821",
    );
    BluetoothCharacteristic? handshakeFinishChar = handshakeService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "0001000a-0000-1000-0000-d8492fffa821",
    );

    if (handshakeStartChar == null || handshakeFinishChar == null) {
      _appendLog("握手相关的 characteristic 未找到！");
      return;
    }

    try {
      // 发送握手启动数据：0x01 + device name
      List<int> deviceNameBytes = "FlutterApp".codeUnits;
      List<int> handshakeStartPayload = [0x01] + deviceNameBytes;
      await handshakeStartChar.write(handshakeStartPayload, withoutResponse: false);
      _appendLog("发送握手启动数据：$handshakeStartPayload");

      // 开启通知并监听握手结果
      await handshakeStartChar.setNotifyValue(true);
      handshakeStartChar.lastValueStream.listen((value) async {
        if (value.isNotEmpty && value[0] == 0x02) {
          _appendLog("收到握手确认（0x02）通知");
          List<int> deviceId = List<int>.generate(16, (i) => i); // 示例设备 ID
          List<int> payloadId = [0x03] + deviceId;
          await handshakeFinishChar.write(payloadId, withoutResponse: false);
          _appendLog("发送设备 ID 数据：$payloadId");

          List<int> payloadName = [0x04] + deviceNameBytes;
          await handshakeFinishChar.write(payloadName, withoutResponse: false);
          _appendLog("发送设备名称数据：$payloadName");

          List<int> payloadType = [0x05, 0x02]; // 0x02 表示 Android
          await handshakeFinishChar.write(payloadType, withoutResponse: false);
          _appendLog("发送设备类型数据：$payloadType");

          List<int> finishPayload = [0x01];
          await handshakeFinishChar.write(finishPayload, withoutResponse: false);
          _appendLog("发送握手结束标识：$finishPayload");
        } else {
          _appendLog("收到握手通知：$value");
        }
      });
    } catch (e) {
      _appendLog("握手过程中出现异常：$e");
    }
  }

  // 发送拍照命令
  Future<void> _takePhoto() async {
    if (_connectedDevice == null) {
      _appendLog("未连接设备，请先连接！");
      return;
    }
    BluetoothService? cameraService = _services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == "00030000-0000-1000-0000-d8492fffa821",
    );
    if (cameraService == null) {
      _appendLog("相机操作服务未找到！");
      return;
    }

    BluetoothCharacteristic? shootingChar = cameraService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "00030030-0000-1000-0000-d8492fffa821",
    );
    if (shootingChar == null) {
      _appendLog("拍摄按键 characteristic 未找到！");
      return;
    }

    try {
      await shootingChar.write([0x00, 0x01], withoutResponse: false);
      _appendLog("发送快门按下命令");
      await Future.delayed(Duration(milliseconds: 200));
      await shootingChar.write([0x00, 0x02], withoutResponse: false);
      _appendLog("发送快门释放命令");
    } catch (e) {
      _appendLog("拍照过程中出现异常：$e");
    }
  }

  Future<void> _startVideo() async {
    if (_connectedDevice == null) {
      _appendLog("未连接设备，请先连接！");
      return;
    }
    BluetoothService? cameraService = _services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == "00030000-0000-1000-0000-d8492fffa821",
    );
    if (cameraService == null) {
      _appendLog("相机操作服务未找到！");
      return;
    }

    BluetoothCharacteristic? shootingChar = cameraService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "00030030-0000-1000-0000-d8492fffa821",
    );
    if (shootingChar == null) {
      _appendLog("拍摄按键 characteristic 未找到！");
      return;
    }

    try {
      await shootingChar.write([0x00, 0x10], withoutResponse: false);
      _appendLog("发送开始录制命令");
    } catch (e) {
      _appendLog("录制过程中出现异常：$e");
    }
  }

  Future<void> _stopVideo() async {
    if (_connectedDevice == null) {
      _appendLog("未连接设备，请先连接！");
      return;
    }
    BluetoothService? cameraService = _services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == "00030000-0000-1000-0000-d8492fffa821",
    );
    if (cameraService == null) {
      _appendLog("相机操作服务未找到！");
      return;
    }

    BluetoothCharacteristic? shootingChar = cameraService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == "00030030-0000-1000-0000-d8492fffa821",
    );
    if (shootingChar == null) {
      _appendLog("拍摄按键 characteristic 未找到！");
      return;
    }

    try {
      await shootingChar.write([0x00, 0x11], withoutResponse: false);
      _appendLog("发送停止录制命令");
    } catch (e) {
      _appendLog("录制过程中出现异常：$e");
    }
  }

  // 构建设备列表
  Widget _buildDeviceList() {
    return Container(
      height: 200,
      child: _scanResults.isEmpty
          ? Center(child: Text("未扫描到设备"))
          : ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          final result = _scanResults[index];
          return ListTile(
            title: Text(result.device.platformName.isNotEmpty ? result.device.platformName : "未知设备"),
            subtitle: Text(result.device.remoteId.toString()),
            trailing: ElevatedButton(
              child: Text("连接"),
              onPressed: () => _connectToDevice(result.device),
            ),
          );
        },
      ),
    );
  }

  // 构建握手与拍照按钮
  Widget _buildControlButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _performHandshake,
          child: Text("执行握手"),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _takePhoto,
          child: Text("拍照"),
        ),
        ElevatedButton(
          onPressed: _startVideo,
          child: Text("开始录制"),
        ),
        ElevatedButton(
          onPressed: _stopVideo,
          child: Text("停止录制"),
        ),
        ElevatedButton(
          onPressed: _setLocation,
          child: Text("设置位置信息"),
        ),
      ],
    );
  }

  // 构建日志显示区域
  Widget _buildLogArea() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(8),
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Text(_log, style: TextStyle(fontFamily: 'monospace')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Toolbox"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 显示已连接设备状态
              if (_connectedDevice != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "已连接设备: ${_connectedDevice!.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              // 扫描按钮及进度指示器
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    child: Text("扫描设备"),
                  ),
                  if (_isScanning)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              _buildDeviceList(),
              SizedBox(height: 10),
              _buildControlButtons(),
              SizedBox(height: 20),
              Text("日志：", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildLogArea(),
            ],
          ),
        ),
      ),
    );
  }
}
