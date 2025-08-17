


import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/view/widgets/add_button.dart';
import 'package:todo_app/view/widgets/search_bar.dart' as custom;
import 'package:todo_app/view/widgets/stream_builder.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String _searchQuery = ''; 

  // Method to handle search query 
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          "ToDoX",
          style: TextStyle(
            color: primary,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      
      resizeToAvoidBottomInset: true,
      body:
      
         SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search and Add button row - fixed at top
                Row(
                  children: [
                    Expanded(
                      flex: 2, 
                      child: custom.SearchBar(onSearchChanged: _onSearchChanged), 
                    ),
                    const SizedBox(width: 9),
                    const Expanded(child: AddButton()), 
                  ],
                ),
                const SizedBox(height: 25),
                // Search results
                Expanded(
                  child: TaskStreamWidget(searchQuery: _searchQuery), 
                ),
              ],
            ),
          ),
        ),
      // ),
    );
  }
}
