import 'package:flutter/material.dart';

/// Toggle heart/favorite button ใช้ได้ทุกหน้า
/// ส่ง [initialValue] เพื่อกำหนดสถานะเริ่มต้น (เช่น จาก database)
/// ส่ง [onToggle] เพื่อเชื่อม API — ต้อง return Future<bool> ว่าสำเร็จหรือไม่
class HeartButton extends StatefulWidget {
  /// สถานะเริ่มต้น (true = กดหัวใจแล้ว, false = ยังไม่กด)
  final bool initialValue;

  /// เรียกเมื่อกดปุ่ม ส่งค่าใหม่ (true/false) ไปให้ฟังก์ชันนี้จัดการ (เช่น ยิง API)
  /// ต้อง return Future<bool> — true = สำเร็จ (คงสถานะใหม่ไว้), false = ล้มเหลว (revert กลับ)
  final Future<bool> Function(bool newValue)? onToggle;

  /// ขนาดไอคอน
  final double size;

  /// สีตอนกดแล้ว (default: แดง)
  final Color activeColor;

  /// สีตอนยังไม่กด (default: เทา)
  final Color inactiveColor;

  const HeartButton({
    super.key,
    this.initialValue = false,
    this.onToggle,
    this.size = 28,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late bool _isActive;
  bool _isLoading = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialValue;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(covariant HeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ถ้า parent ส่งค่าเริ่มต้นใหม่มา (เช่นโหลดข้อมูลใหม่จาก server) ให้ sync ตาม
    if (oldWidget.initialValue != widget.initialValue) {
      _isActive = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isLoading) return; // กันกดซ้ำระหว่างรอ API ตอบ

    final newValue = !_isActive;

    // อัปเดต UI ทันที (optimistic update) ให้รู้สึกลื่นไหล
    setState(() {
      _isActive = newValue;
    });
    _controller.forward().then((_) => _controller.reverse());

    if (widget.onToggle == null) return; // ถ้าไม่มี callback ก็จบแค่ UI local

    setState(() => _isLoading = true);
    try {
      final success = await widget.onToggle!(newValue);
      if (!success && mounted) {
        // API ล้มเหลว → revert กลับสถานะเดิม
        setState(() => _isActive = !newValue);
      }
    } catch (e) {
      // เกิด exception → revert กลับสถานะเดิมเช่นกัน
      if (mounted) {
        setState(() => _isActive = !newValue);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: _isLoading
            ? SizedBox(
                width: widget.size,
                height: widget.size,
                child: Padding(
                  padding: EdgeInsets.all(widget.size * 0.15),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.activeColor,
                  ),
                ),
              )
            : Icon(
                _isActive ? Icons.favorite : Icons.favorite_border,
                color: _isActive ? widget.activeColor : widget.inactiveColor,
                size: widget.size,
              ),
      ),
    );
  }
}