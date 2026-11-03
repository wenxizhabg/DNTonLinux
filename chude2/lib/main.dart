import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}


class ChipLabel extends StatelessWidget {
  const ChipLabel({super.key, required this.name});

  final String name;                       // thuộc tính đặc trưng

  @override
  Widget build(BuildContext context) {     // trả về các khối bên trong
    return Column (
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.memory),
        Text(name),
      ],
    );
  }
}

// Class 1: Widget. Vẫn bất biến, chỉ là cấu hình
class CounterBox extends StatefulWidget {
  const CounterBox({super.key, required this.label});
  final String label;                         // cấu hình, không đổi

  @override
  State<CounterBox> createState() => _CounterBoxState();   // tạo object State
}

// Class 2: State. Thay đổi được và tồn tại lâu dài
class _CounterBoxState extends State<CounterBox> {
  int count = 0;                              // KHÔNG final, dữ liệu thay đổi

  @override
  Widget build(BuildContext context) {        // build() nằm ở State
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${widget.label}: $count'),      // widget.label = đọc cấu hình từ class 1
        ElevatedButton(
          onPressed: () {
            setState(() {                     // báo framework: dữ liệu đổi rồi
              count++;
            });
          },
          child: const Text('+1'),
        ),
      ],
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      title: 'chude2',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: Scaffold(
        appBar: AppBar(title: const Text('Chủ đề 2')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChipLabel(name: 'ESP32'),
              ChipLabel(name: 'SN32F407'),
              CounterBox(label: 'Counter 1'),
              CounterBox(label: 'Counter 2'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},              // hàm rỗng, bấm chưa làm gì
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
