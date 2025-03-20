### Service: 00010000-0000-1000-0000-d8492fffa821

| 操作类型            | 长度 | hex 数据                                           | utf8 数据              | gatt-char                                      | 备注              |
|---------------------|------|----------------------------------------------------|------------------------|------------------------------------------------|-------------------|
| writeCharacteristic | 11   | 01 32 32 30 32 31 32 31 31 52 43                   | 22021211RC            | 00010006-0000-1000-0000-d8492fffa821            | 写入设备ID        |
| onCharacteristicRead| 4    | 0f 00 00 00                                       |                       | 0001000b-0000-1000-0000-d8492fffa821            | 读取配对信息      |
| onCharacteristicRead| 1    | 01                                               |                       | 00010005-0000-1000-0000-d8492fffa821            | 未知              |
| writeCharacteristic | 17   | 03 51 fe a8 ab de 35 42 bf a3 4d e1 b5 dd 54 61 c6 | Q...5B..M..Ta.        | 0001000a-0000-1000-0000-d8492fffa821            | 写入 device id    |
| writeCharacteristic | 11   | 04 32 32 30 32 31 32 31 31 52 43                   | 22021211RC            | 0001000a-0000-1000-0000-d8492fffa821            | 写入 device name  |
| writeCharacteristic | 2    | 05 02                                            |                      | 0001000a-0000-1000-0000-d8492fffa821            | 写入 device type  |
| writeCharacteristic | 1    | 01                                               |                       | 0001000a-0000-1000-0000-d8492fffa821            | 完成握手          |
| writeCharacteristic | 1    | 06                                               |                       | 0001000a-0000-1000-0000-d8492fffa821            | 未知              |
| writeCharacteristic | 1    | 07                                               |                       | 0001000a-0000-1000-0000-d8492fffa821            | 未知              |

---

### Service: 00020000-0000-1000-0000-d8492fffa821

| 操作类型            | 长度 | hex 数据                                         | utf8 数据            | gatt-char                                      | 备注                |
|---------------------|------|--------------------------------------------------|----------------------|------------------------------------------------|---------------------|
| onCharacteristicRead| 4    | 7f 00 00 00                                     |                     | 00020001-0000-1000-0000-d8492fffa821            | 未知                |
| writeCharacteristic | 1    | 0a                                              |                      | 00020002-0000-1000-0000-d8492fffa821            | 生成 AP 名称和密码  |
| onCharacteristicRead| 20   | 45 4f 53 52 38 2d 38 35 39 5f 43 61 6e 6f 6e 30 41 00 00 00 | EOSR8-859_Canon0A | 00020004-0000-1000-0000-d8492fffa821            | 读取 Wi-Fi SSID     |
| onCharacteristicRead| 8    | 78 73 58 34 38 53 35 39                          | xsX48S59             | 00020006-0000-1000-0000-d8492fffa821            | 读取 Wi-Fi 密码     |
| onCharacteristicRead| 20   | 16 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | 	               | 00020005-0000-1000-0000-d8492fffa821            | 未知                |

---

### Service: 00030000-0000-1000-0000-d8492fffa821

| 操作类型            | 长度 | hex 数据               | utf8 数据 | gatt-char                                      | 备注  |
|---------------------|------|------------------------|-----------|------------------------------------------------|-------|
| onCharacteristicRead| 3    | 01 01 01              |        | 00030001-0000-1000-0000-d8492fffa821            | 未知  |

---

### Service: 00040000-0000-1000-0000-d8492fffa821

| 操作类型            | 长度 | hex 数据             | utf8 数据 | gatt-char                                      | 备注  |
|---------------------|------|----------------------|-----------|------------------------------------------------|-------|
| onCharacteristicRead| 3    | 03 13 00             |         | 00040001-0000-1000-0000-d8492fffa821            | 未知  |
| onCharacteristicRead| 2    | 01 00                |          | 00040003-0000-1000-0000-d8492fffa821            | 未知  |
| writeCharacteristic | 8    | 05 00 00 00 00 00 00 00 |       | 00040002-0000-1000-0000-d8492fffa821            | 未知  |

---

### Service: 0000180a-0000-1000-8000-00805f9b34fb

| 操作类型            | 长度 | hex 数据                                     | utf8 数据      | gatt-char                                      | 备注          |
|---------------------|------|----------------------------------------------|----------------|------------------------------------------------|---------------|
| onCharacteristicRead| 11   | 43 61 6e 6f 6e 20 49 6e 63 2e 00             | Canon Inc.     | 00002a29-0000-1000-8000-00805f9b34fb           | 设备制造商信息|
| onCharacteristicRead| 5    | 33 33 30 63 00                               | 330c           | 00002a24-0000-1000-8000-00805f9b34fb           | 设备型号      |
| onCharacteristicRead| 6    | 31 2e 30 2e 30 00                            | 1.0.0          | 00002a26-0000-1000-8000-00805f9b34fb           | 固件版本      |
| onCharacteristicRead| 6    | 31 2e 30 2e 30 00                            | 1.0.0          | 00002a28-0000-1000-8000-00805f9b34fb           | 软件版本      |
| onCharacteristicRead| 20   | 30 39 32 30 32 32 30 30 30 31 34 33 00 00 00 00 00 00 00 00 | 092022000143 | 00002a25-0000-1000-8000-00805f9b34fb           | 序列号        |

---

pair
```shell
# 写入设备标识符 (设备ID)
writeCharacteristic: len: 11 | hex: 01 32 32 30 32 31 32 31 31 52 43 | utf8: 22021211RC | writeType: 2 | gatt-char: 00010006-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821

# 读取配对信息
onCharacteristicRead: len: 4 | hex: 0f 00 00 00 | utf8: ???? | status: 0 | gatt-char: 0001000b-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821

# 读取设备制造商信息
onCharacteristicRead: len: 11 | hex: 43 61 6e 6f 6e 20 49 6e 63 2e 00 | utf8: Canon Inc. | status: 0 | gatt-char: 00002a29-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb

# 读取设备型号
onCharacteristicRead: len: 5 | hex: 33 33 30 63 00 | utf8: 330c | status: 0 | gatt-char: 00002a24-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb

# 读取固件版本
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0 | status: 0 | gatt-char: 00002a26-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb

# 读取软件版本
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0 | status: 0 | gatt-char: 00002a28-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb

# 读取序列号
onCharacteristicRead: len: 20 | hex: 30 39 32 30 32 32 30 30 30 31 34 33 00 00 00 00 00 00 00 00 | utf8: 092022000143 | status: 0 | gatt-char: 00002a25-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb

# 未知
onCharacteristicRead: len: 1 | hex: 01 | utf8:  | status: 0 | gatt-char: 00010005-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821

# 未知
onCharacteristicRead: len: 4 | hex: 7f 00 00 00 | utf8:  | status: 0 | gatt-char: 00020001-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821

# 未知
onCharacteristicRead: len: 3 | hex: 01 01 01 | utf8:  | status: 0 | gatt-char: 00030001-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821

# 未知
onCharacteristicRead: len: 3 | hex: 03 13 00 | utf8:  | status: 0 | gatt-char: 00040001-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821

# 未知
onCharacteristicRead: len: 2 | hex: 01 00 | utf8:  | status: 0 | gatt-char: 00040003-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821

------------------------------------------------
# gatt-char: 0001000a-0000-1000-0000-d8492fffa821

# 写入 device id
writeCharacteristic: len: 17 | hex: 03 51 fe a8 ab de 35 42 bf a3 4d e1 b5 dd 54 61 c6 | utf8: Q...5B..M..Ta. | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821

# 写入 device name
writeCharacteristic: len: 11 | hex: 04 32 32 30 32 31 32 31 31 52 43 | utf8: 22021211RC | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821

# 写入 device type
writeCharacteristic: len: 2 | hex: 05 02 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821

------------------------------------------------

# 写入 0a 让相机生成 AP 名称和密码
writeCharacteristic: len: 1 | hex: 0a | utf8:  | writeType: 2 | gatt-char: 00020002-0000-1000-0000-d8492fffa821

# 未知
writeCharacteristic: len: 8 | hex: 05 00 00 00 00 00 00 00 | utf8:  | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821

------------------------------------------------

# 读取 Wi-Fi SSID
onCharacteristicRead: len: 20 | hex: 45 4f 53 52 38 2d 38 35 39 5f 43 61 6e 6f 6e 30 41 00 00 00 | utf8: EOSR8-859_Canon0A | status: 0 | gatt-char: 00020004-0000-1000-0000-d8492fffa821

# 读取 Wi-Fi 密码
onCharacteristicRead: len: 8 | hex: 78 73 58 34 38 53 35 39 | utf8: xsX48S59 | status: 0 | gatt-char: 00020006-0000-1000-0000-d8492fffa821

------------------------------------------------

# 未知
onCharacteristicRead: len: 20 | hex: 16 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | utf8: 	 | status: 0 | gatt-char: 00020005-0000-1000-0000-d8492fffa821

------------------------------------------------
# 完成握手
writeCharacteristic: len: 1 | hex: 01 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821

------------------------------------------------
# 未知
writeCharacteristic: len: 1 | hex: 06 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 07 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821
```

配对后重新启动 app
```shell
onCharacteristicRead: len: 4 | hex: 0f 00 00 00 | utf8: ?????? | status: 0 | gatt-char: 0001000b-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 11 | hex: 43 61 6e 6f 6e 20 49 6e 63 2e 00 | utf8: Canon Inc.?? | status: 0 | gatt-char: 00002a29-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 5 | hex: 33 33 30 63 00 | utf8: 330c?? | status: 0 | gatt-char: 00002a24-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0?? | status: 0 | gatt-char: 00002a26-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0?? | status: 0 | gatt-char: 00002a28-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 20 | hex: 30 39 32 30 32 32 30 30 30 31 34 33 00 00 00 00 00 00 00 00 | utf8: 092022000143???????????????? | status: 0 | gatt-char: 00002a25-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 1 | hex: 01 | utf8:  | status: 0 | gatt-char: 00010005-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 4 | hex: 7f 00 00 00 | utf8: ?????? | status: 0 | gatt-char: 00020001-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 3 | hex: 01 01 01 | utf8:  | status: 0 | gatt-char: 00030001-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 3 | hex: 03 13 00 | utf8: ?? | status: 0 | gatt-char: 00040001-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 2 | hex: 05 00 | utf8: ?? | status: 0 | gatt-char: 00040003-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 0a | utf8: 
                                                                                                     | writeType: 2 | gatt-char: 00020002-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 8 | hex: 05 00 00 00 00 00 00 00 | utf8: ?????????????? | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 20 | hex: 45 4f 53 52 38 2d 38 35 39 5f 43 61 6e 6f 6e 30 41 00 00 00 | utf8: EOSR8-859_Canon0A?????? | status: 0 | gatt-char: 00020004-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 8 | hex: 78 73 58 34 38 53 35 39 | utf8: xsX48S59 | status: 0 | gatt-char: 00020006-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 20 | hex: 16 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | utf8: ??????	?????????????????????????????? | status: 0 | gatt-char: 00020005-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 01 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 06 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 07 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
```

唤醒相机并打开蓝牙遥控器
```shell
onCharacteristicRead: len: 4 | hex: 0f 00 00 00 | utf8: ?????? | status: 0 | gatt-char: 0001000b-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 11 | hex: 43 61 6e 6f 6e 20 49 6e 63 2e 00 | utf8: Canon Inc.?? | status: 0 | gatt-char: 00002a29-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 5 | hex: 33 33 30 63 00 | utf8: 330c?? | status: 0 | gatt-char: 00002a24-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0?? | status: 0 | gatt-char: 00002a26-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 6 | hex: 31 2e 30 2e 30 00 | utf8: 1.0.0?? | status: 0 | gatt-char: 00002a28-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 20 | hex: 30 39 32 30 32 32 30 30 30 31 34 33 00 00 00 00 00 00 00 00 | utf8: 092022000143???????????????? | status: 0 | gatt-char: 00002a25-0000-1000-8000-00805f9b34fb | service: 0000180a-0000-1000-8000-00805f9b34fb
onCharacteristicRead: len: 1 | hex: 01 | utf8:  | status: 0 | gatt-char: 00010005-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 4 | hex: 7f 00 00 00 | utf8: ?????? | status: 0 | gatt-char: 00020001-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 3 | hex: 01 01 01 | utf8:  | status: 0 | gatt-char: 00030001-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 3 | hex: 03 13 00 | utf8: ?? | status: 0 | gatt-char: 00040001-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 2 | hex: 05 00 | utf8: ?? | status: 0 | gatt-char: 00040003-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 0a | utf8: 
                                                                                                     | writeType: 2 | gatt-char: 00020002-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 8 | hex: 05 00 00 00 00 00 00 00 | utf8: ?????????????? | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 20 | hex: 45 4f 53 52 38 2d 38 35 39 5f 43 61 6e 6f 6e 30 41 00 00 00 | utf8: EOSR8-859_Canon0A?????? | status: 0 | gatt-char: 00020004-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 8 | hex: 78 73 58 34 38 53 35 39 | utf8: xsX48S59 | status: 0 | gatt-char: 00020006-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
onCharacteristicRead: len: 20 | hex: 16 00 00 00 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 | utf8: ??????	?????????????????????????????? | status: 0 | gatt-char: 00020005-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 01 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 06 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 07 | utf8:  | writeType: 2 | gatt-char: 0001000a-0000-1000-0000-d8492fffa821 | service: 00010000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 1 | hex: 03 | utf8:  | writeType: 2 | gatt-char: 00030010-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
关闭蓝牙遥控器并暂停相机
```shell
writeCharacteristic: len: 1 | hex: 05 | utf8:  | writeType: 2 | gatt-char: 00030010-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```

关闭蓝牙遥控器并暂停相机
```shell
writeCharacteristic: len: 1 | hex: 05 | utf8:  | writeType: 2 | gatt-char: 00030010-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```

启动wifi
```shell
writeCharacteristic: len: 1 | hex: 01 | utf8:  | writeType: 2 | gatt-char: 00020002-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
```

启动wifi时取消
```shell
writeCharacteristic: len: 1 | hex: 03 | utf8:  | writeType: 2 | gatt-char: 00020002-0000-1000-0000-d8492fffa821 | service: 00020000-0000-1000-0000-d8492fffa821
```

选择 gps 设备接收器作为位置接收设备
```shell
writeCharacteristic: len: 8 | hex: 06 01 00 00 00 00 00 00 | utf8: ???????????? | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
```
选择手机作为位置接收设备
```shell
writeCharacteristic: len: 8 | hex: 06 04 00 00 00 00 00 00 | utf8: ???????????? | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
```
关闭 gps
```shell
writeCharacteristic: len: 8 | hex: 06 00 00 00 00 00 00 00 | utf8: ?????????????? | writeType: 2 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821
```
设置位置
```shell
writeCharacteristic: len: 20 | hex: 04 53 8a 8a 1c 42 57 a7 16 ec 42 2b 5c eb 24 43 43 34 dc 67 | utf8: S��BW��B+\�$CC4�g | writeType: 1 | gatt-char: 00040002-0000-1000-0000-d8492fffa821 | service: 00040000-0000-1000-0000-d8492fffa821=
```

拍摄
```shell
writeCharacteristic: len: 2 | hex: 00 01 | utf8: ?? | writeType: 2 | gatt-char: 00030030-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 2 | hex: 00 02 | utf8: ?? | writeType: 2 | gatt-char: 00030030-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
开始录制，停止录制
```shell
writeCharacteristic: len: 2 | hex: 00 10 | utf8: ?? | writeType: 2 | gatt-char: 00030030-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 2 | hex: 00 11 | utf8: ?? | writeType: 2 | gatt-char: 00030030-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```

左键
```shell
writeCharacteristic: len: 4 | hex: 04 00 00 80 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 04 00 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```

右键
```shell
writeCharacteristic: len: 4 | hex: 08 00 00 80 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 08 00 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
上键
```shell
writeCharacteristic: len: 4 | hex: 01 00 00 80 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 01 00 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
下键
```shell
writeCharacteristic: len: 4 | hex: 02 00 00 80 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 02 00 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```

打开自动切换图片/关闭自动切换图片
```shell
writeCharacteristic: len: 4 | hex: 00 01 00 c0 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 00 01 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
缩小
```shell
writeCharacteristic: len: 4 | hex: 80 00 00 80 | utf8: �????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 80 00 00 40 | utf8: �????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
放大
```shell
writeCharacteristic: len: 4 | hex: 40 00 00 80 | utf8: @????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 40 00 00 40 | utf8: @????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
中间键
```shell
writeCharacteristic: len: 4 | hex: 10 00 00 80 | utf8: ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 10 00 00 40 | utf8: ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```
还原键
```shell
writeCharacteristic: len: 4 | hex: 20 00 00 c0 | utf8:  ????� | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
writeCharacteristic: len: 4 | hex: 20 00 00 40 | utf8:  ????@ | writeType: 2 | gatt-char: 00030020-0000-1000-0000-d8492fffa821 | service: 00030000-0000-1000-0000-d8492fffa821
```



