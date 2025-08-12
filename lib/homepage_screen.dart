import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/services/firebase_service.dart';
import 'package:todo_app/widgets/bottom_sheet.dart';
import 'package:todo_app/widgets/search_bar.dart';
import 'package:todo_app/widgets/statuscard.dart';
import 'package:todo_app/widgets/stream_builder.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background,
      title: Text("TodoX",style: TextStyle(color: primary,fontSize: 30,fontWeight: FontWeight.w500),),centerTitle: true,),
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
              padding: const EdgeInsets.only(left: 22, right: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 2, child: searchbar()),
                      SizedBox(width: 9),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(17),
                          ),

                          onPressed: () {
                            bottomSheet(context);
                          },

                          child: Row(children:
                          
                          [
                            Text(
                            "Add",
                            style: TextStyle(color: onSurface, fontSize: 18),
                          ),
                           SizedBox(width: 8),
                          Icon(
                            Icons.add_circle_outline,
                            color: onSurface,
                            size: 20,
                            weight: 28.0,
                          ),],)
                          
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Expanded(child: TaskStreamWidget()),

                      
                                  ],
                                ),
                              ),
      

//                  
                  ),
                ],
              ),
            );
          
        
    
    
  }
}

