import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(home: ImplicitDemoApp(), debugShowCheckedModeBanner: false),
);

class ImplicitDemoApp extends StatefulWidget {
  const ImplicitDemoApp({super.key});

  @override
  State<ImplicitDemoApp> createState() => _ImplicitDemoAppState();
}

class _ImplicitDemoAppState extends State<ImplicitDemoApp> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Implicit Animation')),
      body: Center(
        child: GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: _isExpanded ? 260 : 180,
                height: _isExpanded ? 160 : 100,
                color: Colors.amber,
                alignment: Alignment.center,
                child: const Text(
                  'Ease Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                width: _isExpanded ? 260 : 180,
                height: _isExpanded ? 160 : 100,
                color: Colors.indigo,
                alignment: Alignment.center,
                child: const Text(
                  'Ease In',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
