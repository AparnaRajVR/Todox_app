
import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/view/widgets/add_button.dart';
import 'package:todo_app/view/widgets/search_bar.dart';
import 'package:todo_app/view/widgets/stream_builder.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          "TodoX",
          style: TextStyle(
            color: primary,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container(color: background)),
              Expanded(flex: 3, child: Container(color: Color(0xff1A1A1A))),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 16,
            right: 16,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 2, child: searchbar()),
                      const SizedBox(width: 9),
                      const Expanded(child: AddButton()), 
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Expanded(child: TaskStreamWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
