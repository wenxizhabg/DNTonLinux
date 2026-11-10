import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const AnimationDemoApp());

// =====================================================================
// WIDGET GỐC: chỉ lắp ráp cây widget, không chứa logic animation.
// =====================================================================
class AnimationDemoApp extends StatelessWidget {
  const AnimationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('Animation & Gesture Demo')),
        // Cuộn dọc: con nhận chiều cao unbounded → nhiều hàng cũng không overflow.
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          // Wrap: xếp các ô 280x300 theo hàng ngang, hết chỗ thì xuống hàng.
          // Cửa sổ rộng → nhiều cột; cửa sổ hẹp → ít cột.
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              DemoSection(
                title: 'onTap',
                hint: 'AnimatedContainer: đổi kích thước, màu trong 300 ms',
                child: ImplicitBox(),
              ),
              DemoSection(
                title: 'onPressed → forward()',
                hint: 'Controller → Curve → Tween → RotationTransition',
                child: SpinBox(),
              ),
              DemoSection(
                title: 'onPressed → forward() / reverse()',
                hint: 'Staggered: Fade 0–400, Grow 300–800, Turn 700–1000 ms',
                child: StaggeredBox(),
              ),
              DemoSection(
                title: 'onTapDown / onTapUp',
                hint: 'AnimatedScale: co nhẹ khi nhấn giữ (150 ms)',
                child: PressBox(),
              ),
              DemoSection(
                title: 'onDoubleTap',
                hint: 'TweenSequence: tim nảy 1 → 1.4 → 1 (300 ms)',
                child: LikeHeart(),
              ),
              DemoSection(
                title: 'onHorizontalDragUpdate / End',
                hint:
                    'Kéo < 100 px: snap back. Kéo xa hoặc hất > 1000 px/s: xoá',
                child: SwipeCard(),
              ),
              DemoSection(
                title: 'onScaleUpdate',
                hint:
                    'Chụm / xoay 2 ngón (touchpad, cảm ứng); chạm kép: đặt lại',
                child: PinchBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGET DÙNG CHUNG (chỉ phần trình bày)
// =====================================================================
const kLabelStyle = TextStyle(color: Colors.white);

/// Ô 280x300 cho mỗi demo: tên callback + gợi ý + nội dung.
class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.hint,
    required this.child,
  });

  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // SizedBox ép constraints tight 280x300 cho Card → mọi ô bằng nhau.
    return SizedBox(
      width: 280,
      height: 300,
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(), // góc vuông
        clipBehavior: Clip.hardEdge, // cắt phần con bị kéo / phóng ra ngoài ô
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium),
              Text(hint, style: text.bodySmall),
              // Expanded: nội dung lấy toàn bộ chiều cao còn lại, đặt ở giữa.
              Expanded(child: Center(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hộp màu có nhãn, dùng làm "vật thể" được animate.
class DemoBox extends StatelessWidget {
  const DemoBox({
    super.key,
    required this.color,
    required this.label,
    this.width = 100,
    this.height = 100,
  });

  final Color color;
  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: color,
      child: Text(label, textAlign: TextAlign.center, style: kLabelStyle),
    );
  }
}

// =====================================================================
// 1. IMPLICIT: chỉ đổi giá trị đích + setState, Flutter tự nội suy.
//    (Thời điểm 2: thể hiện chuyển đổi trạng thái)
// =====================================================================
class ImplicitBox extends StatefulWidget {
  const ImplicitBox({super.key});

  @override
  State<ImplicitBox> createState() => _ImplicitBoxState();
}

class _ImplicitBoxState extends State<ImplicitBox> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _expanded ? 240 : 120,
        height: 120,
        alignment: Alignment.center,
        color: _expanded ? Colors.teal : Colors.indigo,
        child: const Text('Chạm', style: kLabelStyle),
      ),
    );
  }
}

// =====================================================================
// 2. EXPLICIT: tự giữ AnimationController (dòng thời gian 0 → 1).
// =====================================================================
class SpinBox extends StatefulWidget {
  const SpinBox({super.key});

  @override
  State<SpinBox> createState() => _SpinBoxState();
}

class _SpinBoxState extends State<SpinBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _turns;

  @override
  void initState() {
    super.initState();
    // vsync: this → Ticker gọi controller mỗi khung hình.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Controller (0→1 tuyến tính) → Curve (bẻ cong) → Tween (0→1 vòng).
    _turns = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose(); // dừng Ticker, tránh rò rỉ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // RotationTransition tự lắng nghe _turns → không cần setState.
        RotationTransition(
          turns: _turns,
          child: const DemoBox(color: Colors.deepPurple, label: 'Xoay'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => _controller.forward(from: 0),
          child: const Text('Xoay 360°'),
        ),
      ],
    );
  }
}

// =====================================================================
// 3. STAGGERED: một controller, nhiều Interval chồng lấn nhau.
// =====================================================================
class StaggeredBox extends StatefulWidget {
  const StaggeredBox({super.key});

  @override
  State<StaggeredBox> createState() => _StaggeredBoxState();
}

class _StaggeredBoxState extends State<StaggeredBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _grow;
  late final Animation<double> _turn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Interval(start, end) tính theo tỉ lệ duration: 0.3 ↔ 300 ms.
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4),
    );
    _grow = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8)),
    );
    _turn = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Các ...Transition chỉ đổi lúc vẽ (paint), không đổi layout:
        // hộp vẫn chiếm 100x100 ngay cả khi đang mờ / thu nhỏ.
        FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _grow,
            child: RotationTransition(
              turns: _turn,
              child: const DemoBox(
                color: Colors.orange,
                label: 'Fade\nGrow\nTurn',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: _toggle, child: const Text('Chạy / Đảo ngược')),
      ],
    );
  }
}

// =====================================================================
// 4a. TAP: co nhẹ khi nhấn (Thời điểm 1: phản hồi tức thì)
// =====================================================================
class PressBox extends StatefulWidget {
  const PressBox({super.key});

  @override
  State<PressBox> createState() => _PressBoxState();
}

class _PressBoxState extends State<PressBox> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: const DemoBox(color: Colors.teal, label: 'Nhấn giữ'),
      ),
    );
  }
}

// =====================================================================
// 4b. DOUBLE TAP: tim nảy lên (Thời điểm 3: thu hút chú ý)
// =====================================================================
class LikeHeart extends StatefulWidget {
  const LikeHeart({super.key});

  @override
  State<LikeHeart> createState() => _LikeHeartState();
}

class _LikeHeartState extends State<LikeHeart>
    with SingleTickerProviderStateMixin {
  bool _liked = false;
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // TweenSequence: nửa đầu phóng 1 → 1.4, nửa sau thu 1.4 → 1.
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => _liked = !_liked);
    if (_liked) _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: ScaleTransition(
        scale: _scale,
        child: Icon(
          _liked ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 80,
        ),
      ),
    );
  }
}

// =====================================================================
// 5. DRAG + FLING + SNAP BACK (UX: ngăn thao tác nhầm)
// =====================================================================
class SwipeCard extends StatefulWidget {
  const SwipeCard({super.key});

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  static const _distanceThreshold = 100.0; // px
  static const _velocityThreshold = 1000.0; // px/s

  double _dx = 0;
  bool _dragging = false;
  bool _dismissed = false;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragging = true;
      _dx += details.delta.dx; // cộng dồn độ lệch → bám tay 1:1
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final isFling = velocity.abs() > _velocityThreshold;
    setState(() {
      _dragging = false;
      if (isFling || _dx.abs() > _distanceThreshold) {
        _dismissed = true;
        _dx = (isFling ? velocity.sign : _dx.sign) * 400; // hất ra ngoài
      } else {
        _dx = 0; // chưa qua ngưỡng → snap back
      }
    });
  }

  void _restore() => setState(() {
    _dismissed = false;
    _dx = 0;
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: _dismissed ? null : _onDragUpdate,
          onHorizontalDragEnd: _dismissed ? null : _onDragEnd,
          child: AnimatedContainer(
            // Đang kéo: duration 0 → widget nhảy theo tay, không trễ.
            // Thả tay: 150 ms → nảy về / trượt ra có chuyển động.
            duration: _dragging
                ? Duration.zero
                : const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dx, 0, 0),
            child: AnimatedOpacity(
              opacity: _dismissed ? 0 : 1,
              duration: const Duration(milliseconds: 150),
              child: const DemoBox(
                color: Colors.blueGrey,
                label: 'Vuốt ngang để xoá',
                width: 240,
                height: 80,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('dx = ${_dx.round()} px'),
            TextButton(
              onPressed: _dismissed ? _restore : null,
              child: const Text('Khôi phục'),
            ),
          ],
        ),
      ],
    );
  }
}

// =====================================================================
// 6. SCALE / ROTATION: dùng 2 ngón tay
// =====================================================================
class PinchBox extends StatefulWidget {
  const PinchBox({super.key});

  @override
  State<PinchBox> createState() => _PinchBoxState();
}

class _PinchBoxState extends State<PinchBox> {
  double _scale = 1;
  double _rotation = 0; // radian
  double _baseScale = 1;
  double _baseRotation = 0;
  bool _gesturing = false;

  @override
  Widget build(BuildContext context) {
    // Giống SwipeCard: đang thao tác thì bám tay, thả ra mới animate.
    final duration = _gesturing
        ? Duration.zero
        : const Duration(milliseconds: 300);

    return GestureDetector(
      onScaleStart: (_) => setState(() {
        _gesturing = true;
        _baseScale = _scale; // details.scale tính từ lúc bắt đầu chụm
        _baseRotation = _rotation;
      }),
      onScaleUpdate: (details) => setState(() {
        _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
        _rotation = _baseRotation + details.rotation;
      }),
      onScaleEnd: (_) => setState(() => _gesturing = false),
      onDoubleTap: () => setState(() {
        _scale = 1;
        _rotation = 0;
      }),
      child: AnimatedRotation(
        turns: _rotation / (2 * math.pi), // radian → số vòng
        duration: duration,
        child: AnimatedScale(
          scale: _scale,
          duration: duration,
          child: const DemoBox(color: Colors.pink, label: 'Pinch'),
        ),
      ),
    );
  }
}
