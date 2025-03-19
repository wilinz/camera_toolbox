class BLEDeviceDesc {
  final String name;
  final String remoteId;

  BLEDeviceDesc({
    required this.name,
    required this.remoteId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'remoteId': remoteId,
  };

  factory BLEDeviceDesc.fromJson(Map<String, dynamic> json) {
    return BLEDeviceDesc(
      name: json['name'] ?? '未知设备',
      remoteId: json['remoteId'],
    );
  }

  @override
  String toString() {
    return 'SavedBLEDevice(name: $name, remoteId: $remoteId)';
  }
}
