import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build (BuildContext context) {
    return MaterialApp (
      title: 'Exploration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: Text("Space exploration"),
      ),
      body: Column (
        children: [
          Progress(),
        ]
      )
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build (BuildContext context) {
    return Column (
      children: [
        Text("You are this far away from exploring the whole universal"),
        LinearProgressIndicator (value: 0.7,),
        TaskList (),
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build (BuildContext context) {
    return Column (
      children: [
        TaskItem (label: 'Load the rocket with supplies'),
        TaskItem (label: 'Launch the rocket'),
        TaskItem (label: 'Cirle the home planet'),
        TaskItem (label: 'Head out the first moon'),
        TaskItem (label: 'Launch moon lander #1'),
      ]
    );
  }
}

class TaskItem extends StatefulWidget {
  final String label;

  const TaskItem({super.key, required this.label});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue ?? false;
            });
          },
        ),
        Text(widget.label),
      ],
    );
  }
}