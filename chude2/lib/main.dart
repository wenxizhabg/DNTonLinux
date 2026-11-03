import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}


class ChipLabel extends StatelessWidget {
  const ChipLabel({super.key, required this.name});

  final String name;                       // thuộc tính đặc trưng

  @override
  Widget build(BuildContext context) {     // trả về các khối bên trong
    return Container (
      padding: const EdgeInsets.all(8),
      color: Colors.amber,
      child: Text(name),
    );
  }
}

class OverflowTestWidget extends StatelessWidget {
  const OverflowTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold (
      body: Center (
        child: SizedBox (
          width: 200,
          child: Column (
            children: [
              Row (children: [ChipLabel(name: 'ESP32'), ChipLabel(name: 'STM32')]),
              SizedBox(height: 20),
              Row (children: [ChipLabel(name: 'ESP32-C3 Devkit M1'), ChipLabel(name: 'STM32H503CBT6')]),
            ]
          ),
        ),
      )
    );
  }
}


class CounterBox extends StatefulWidget {
  const CounterBox({super.key, required this.label});
  final String label;                         // cấu hình, không đổi

  @override
  State<CounterBox> createState() => _CounterBoxState();   // tạo object State
}

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
      home: const OverflowTestWidget(),
    );
  }
}
