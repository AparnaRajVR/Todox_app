// import 'package:flutter/material.dart';
// import 'package:todo_app/constants/const.dart';

// class searchbar extends StatefulWidget {
//   const searchbar({
//     super.key,
//   });

//   @override
//   State<searchbar> createState() => _searchbarState();
// }

// class _searchbarState extends State<searchbar> {
//   TextEditingController searchcontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color:boxcolor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: background.withOpacity(0.3),
//             blurRadius: 1,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
    
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
    
//           children: [
//             Icon(Icons.rocket_launch_outlined, color:onSurface),
//             SizedBox(width: 9),
//             Text(
//               "Search...",
//               style: TextStyle(color: Colors.grey, fontSize: 19),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearchChanged; // Callback function for search changes
  
  const SearchBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  bool _hasText = false; // Track if there's text in the search field

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: boxcolor,
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Adjusted padding to prevent overflow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.rocket_launch_outlined, // Always show rocket icon while typing
              color: onSurface,
              size: 24, // Fixed icon size to prevent overflow
            ),
            SizedBox(width: 12), // Increased spacing
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: onSurface, fontSize: 16), // Reduced font size to prevent overflow
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16), // Reduced hint font size
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // Update text state and notify parent widget
                  setState(() {
                    _hasText = value.isNotEmpty; // Track if there's text
                  });
                  widget.onSearchChanged(value);
                },
              ),
            ),
            if (_hasText)
              GestureDetector(
                onTap: () {
                  // Clear search functionality
                  _searchController.clear();
                  setState(() {
                    _hasText = false;
                  });
                  widget.onSearchChanged('');
                },
                child: Icon(
                  Icons.clear, 
                  color: onSurface,
                  size: 20, // Smaller clear icon to prevent overflow
                ),
              ),
          ],
        ),
      ),
    );
  }
}
