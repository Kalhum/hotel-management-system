import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double rating; // เปลี่ยนชื่อเป็น rating ให้ตรงกับที่เรียกใช้
  final double size;
  final Color color;
  final bool isReadOnly;
  final Function(double)? onRatingChanged;

  const StarRating({
    super.key,
    this.rating = 0, // เปลี่ยนชื่อตรงนี้ด้วย
    this.size = 24,
    this.color = Colors.amber,
    this.isReadOnly = false,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  // เพิ่มส่วนนี้: เพื่อให้ดาวอัปเดตเมื่อค่าจากภายนอกเปลี่ยน (เช่น หลังกดส่งรีวิว)
  @override
  void didUpdateWidget(covariant StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      setState(() {
        _currentRating = widget.rating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.isReadOnly
              ? null
              : () {
                  setState(() {
                    _currentRating = index + 1.0;
                  });
                  if (widget.onRatingChanged != null) {
                    widget.onRatingChanged!(_currentRating);
                  }
                },
          child: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: widget.color,
            size: widget.size,
          ),
        );
      }),
    );
  }
}