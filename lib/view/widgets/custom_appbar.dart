import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({
    super.key,
    required
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        
        style: TextStyle(
          color: primary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
     
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
