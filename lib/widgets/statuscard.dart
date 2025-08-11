
import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';

class StatusCard extends StatelessWidget {
  final String label;
  final int count;
  const StatusCard({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: primary)),
          SizedBox(width: 6),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: textcolor),
            child: Text(count.toString(), style: TextStyle(color: onSurface)),
          ),
        ],
      ),
    );
  }
}
