import 'package:chu_de1/sensor_data.dart';

void main() {
  // --- KỊCH BẢN CHẠY THỬ ---
  
  // 1. Nhận luồng dữ liệu đầu tiên (Cảm biến chưa có trong kho)
  Map<String, dynamic> jsonLanthu1 = {"sensor_id": "TEMP_01", "value": 35.5};
  var sensorA = SensorData.fromJson(jsonLanthu1);
  
  // 2. Server tiếp tục gửi dữ liệu nhiệt độ mới của đúng cảm biến TEMP_01 đó
  Map<String, dynamic> jsonLanthu2 = {"sensor_id": "TEMP_01", "value": 37.0};
  var sensorB = SensorData.fromJson(jsonLanthu2);

  // 3. KIỂM CHỨNG:
  print("\n--- KIỂM TRA BỘ NHỚ ---");
  // Hàm identical dùng để kiểm tra xem 2 biến có trỏ chung vào 1 vùng nhớ RAM không
  bool isSameMemory = identical(sensorA, sensorB); 
  print("sensorA và sensorB có cùng chung vùng nhớ không? -> $isSameMemory");
  
  // Do sensorA và sensorB là một, nên giá trị của sensorA cũng tự động cập nhật lên 37.0
  print("Giá trị hiện tại của sensorA là: ${sensorA.value}");
}