class SensorData {
  String id;
  double value;


  // Cache lưu trữ các cảm biến đã khởi tạo. 
  static Map<String, SensorData> sensorList = {};

  SensorData._internal(this.id, this.value);

  factory SensorData.fromJson(Map<String, dynamic> json) {
    String safeId = json['sensor_id'] ?? 'UNKNOWN';
    
    // Vá lỗi Bước 1: Ép kiểu an toàn, không sợ JSON chứa chữ thay vì số
    double safeValue = double.tryParse(json['value'].toString()) ?? -999.0;

    final existingSensor = sensorList[safeId];
    if (existingSensor != null) {
      existingSensor.value = safeValue;
      return existingSensor;
    }

    final newSensor = SensorData._internal(safeId, safeValue);
    sensorList[safeId] = newSensor;
    return newSensor;
  }
}