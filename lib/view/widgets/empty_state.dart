import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: textcolor,
          ),
          SizedBox(height: 22),
          Text(
            'You don\'t have any tasks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start adding tasks and manage your\ntime effectively',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: textcolor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
