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
