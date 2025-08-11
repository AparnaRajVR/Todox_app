import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';

class searchbar extends StatelessWidget {
  const searchbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color:boxcolor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: background.withOpacity(0.3),
            blurRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
    
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
    
          children: [
            Icon(Icons.rocket_launch_outlined, color:Colors.red),
            SizedBox(width: 9),
            Text(
              "Search...",
              style: TextStyle(color: Colors.grey, fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }
}
