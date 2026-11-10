import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    home: AnimationDemoApp(),
    debugShowCheckedModeBanner: false,
  ),
);

class AnimationDemoApp extends StatelessWidget {
  const AnimationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Demo')),
      body: const Column(
        children: [
          ImplicitAnimationSection(),
          ExplicitAnimationSection(),
          GestureDragSection(),
        ],
      ),
    );
  }
}

// Mục 1: Implicit Animation
class ImplicitAnimationSection extends StatefulWidget {
  const ImplicitAnimationSection({super.key});

  @override
  State<ImplicitAnimationSection> createState() =>
      _ImplicitAnimationSectionState();
}

class _ImplicitAnimationSectionState extends State<ImplicitAnimationSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          const Text('1. Implicit Animation'),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImplicitBox(
                  label: 'Ease Out',
                  color: Colors.amber,
                  curve: Curves.easeOut,
                ),
                _buildImplicitBox(
                  label: 'Ease In',
                  color: Colors.indigo,
                  curve: Curves.easeIn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImplicitBox({
    required String label,
    required Color color,
    required Curve curve,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: curve,
      width: _isExpanded ? 260 : 180,
      height: _isExpanded ? 160 : 100,
      color: color,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Mục 2: Explicit Animation
class ExplicitAnimationSection extends StatefulWidget {
  const ExplicitAnimationSection({super.key});

  @override
  State<ExplicitAnimationSection> createState() =>
      _ExplicitAnimationSectionState();
}

class _ExplicitAnimationSectionState extends State<ExplicitAnimationSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          const Text('2. Explicit Animation'),
          const SizedBox(height: 16),
          RotationTransition(
            turns: _rotation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _triggerAnimation,
            child: const Text('Kích hoạt xoay 360°'),
          ),
        ],
      ),
    );
  }
}


// Mục 3: Gesture Drag
class GestureDragSection extends StatefulWidget {
  const GestureDragSection({super.key});

  @override
  State<GestureDragSection> createState() => _GestureDragSectionState();
}

class _GestureDragSectionState extends State<GestureDragSection> {
  double _dragOffsetX = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          const Text('3. Gesture Drag'),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _dragOffsetX += details.delta.dx;
              });
            },
            onPanEnd: (_) {
              setState(() {
                _dragOffsetX = 0.0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffsetX, 0, 0),
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Vuốt sang 2 bên\n'
                'Độ lệch: ${_dragOffsetX.round()}px',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
