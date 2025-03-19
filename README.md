# **佳能相机控制 APP**

## 截图
<img src="readme/1.png" alt="1.png" style="width:300px;" />

## **协议说明**

### **GPS 功能**

使用手机作为 GPS 设备，向相机发送位置信息。

#### **操作步骤：**

1. **选择手机作为 GPS 设备**（发送初始化数据）。
2. **发送位置信息数据**（定期发送 GPS 数据）。

------

## **选择手机作为 GPS 设备数据格式 (Enable Phone as GPS Device Format)**

此数据格式用于通知相机，选择手机作为 GPS 设备。

### **数据字段 (Data Fields)**

| **字段 (Field)**              | **大小 (Size)**    | **说明 (Description)**                                       |
| ----------------------------- | ------------------ | ------------------------------------------------------------ |
| **命令 ID (Command ID)**      | 1 字节 (1 Byte)    | 固定值 `06` (Fixed value `06`)                               |
| **设备类型 (Device Type)** | 1 字节 (1 Byte)    | 手机为 `04` (Phone value `04`)                        |
| **保留字节 (Reserved Bytes)** | 6 字节 (6 Bytes)   | 固定填充 `00 00 00 00 00 00` (Fixed padding `00 00 00 00 00 00`) |
| **GATT 特征值 UUID**          | 16 字节 (16 Bytes) | `00040002-0000-1000-0000-d8492fffa821`                       |

------

### **示例数据 (Example Data)**

#### **选择手机作为 GPS 设备**

**原始数据 (Raw Data):**

```
06 04 00 00 00 00 00 00
```

**UUID:**

```
00040002-0000-1000-0000-d8492fffa821
```

------

## **位置信息数据格式 (Location Data Format)**

本数据格式用于描述特定蓝牙 GATT 特征值的编码方式，包括地理位置信息和时间戳。
 向相机发送位置信息时，需使用此数据格式。

### **数据字段 (Data Fields)**

| **字段 (Field)**                                | **大小 (Size)**    | **说明 (Description)**                                       |
| ----------------------------------------------- | ------------------ | ------------------------------------------------------------ |
| **命令 ID (Command ID)**                        | 1 字节 (1 Byte)    | 固定值 `04` (Fixed value `04`)                               |
| **南北纬度标志 (Latitude Hemisphere Flag)**     | 1 字节 (1 Byte)    | `'S'` 表示南纬，`'N'` 表示北纬 (ASCII: 'S' for South, 'N' for North) |
| **纬度 (Latitude)**                             | 4 字节 (4 Bytes)   | 小端 (Little-endian) IEEE 754 单精度浮点数 (IEEE 754 floating-point) |
| **东西经度标志 (Longitude Hemisphere Flag)**    | 1 字节 (1 Byte)    | `'W'` 表示西经，`'E'` 表示东经 (ASCII: 'W' for West, 'E' for East) |
| **经度 (Longitude)**                            | 4 字节 (4 Bytes)   | 小端 (Little-endian) IEEE 754 单精度浮点数 (IEEE 754 floating-point) |
| **填充位 (Padding Byte)**                       | 1 字节 (1Bytes)    | 固定值 `0x2B` (`+` 的 ASCII 表示) (Fixed value '0x2B', ASCII representation of `+`) |
| **海拔 (Altitude)**                             | 4 字节 (4 Bytes)   | 小端 (Little-endian) IEEE 754 单精度浮点数 (IEEE 754 floating-point) |
| **时间戳 (Timestamp)**                          | 4 字节 (4 Bytes)   | 小端 (Little-endian) 32 位无符号整数，表示 UNIX 时间戳 (秒) (Little-endian 32-bit unsigned integer, UNIX timestamp in seconds) |
| **GATT 特征值 UUID (GATT Characteristic UUID)** | 16 字节 (16 Bytes) | 设备特定的蓝牙 GATT 特征值 UUID (Device-specific Bluetooth GATT characteristic UUID) |

------

### **示例数据 (Example Data)**

#### **GPS 位置信息示例**

**原始数据 (Raw Data):**

```
04 4e d7 94 b1 41 45 ec 14 e3 42 2b 01 80 30 43 59 28 d3 67
```

- **解析 (Decoded Values):**
  - **控制位:** `04`
  - **纬度方向:** `N`
  - **纬度:** `22.198°`
  - **经度方向:** `E`
  - **经度:** `113.541°`
  - **填充:** `0x2B ('+')`
  - **海拔:** `176.5m`
  - **时间戳:** `1741891673`（UTC 时间 `2025-03-13 06:47:53`）

**UUID:**

```
00040002-0000-1000-0000-d8492fffa821
```

