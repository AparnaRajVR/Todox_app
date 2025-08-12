import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/view/widgets/bottom_sheet.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(17),
      ),
      onPressed: () {
        bottomSheet(context); // Opens the bottom sheet
      },
      child: Row(
        children: [
          const Text(
            "Add",
            style: TextStyle(color: onSurface, fontSize: 18),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.add_circle_outline,
            color: onSurface,
            size: 20,
          ),
        ],
      ),
    );
  }
}
