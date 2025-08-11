 import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {

  static Future<void>storetask(  String taskname)async{
    final collection = FirebaseFirestore.instance.collection("Dailytask");
   final docRef= collection.doc();
   await docRef.set({
      "taskid":docRef.id,
       "name" : taskname,
       "status":"pending",
      "createdAt" :FieldValue.serverTimestamp(),

    } );
  
}

static Stream<QuerySnapshot>gettask(){
  return FirebaseFirestore.instance.collection
  ("Dailytask").orderBy("createdAt",descending:true).snapshots();
}

  
  static Future<void>updatetaskstatus(String taskid, String newstatus)async{
    try{
    await  FirebaseFirestore.instance.collection("Dailytask").doc(taskid).update({'status':newstatus});
    
  }
catch(e){
  throw Exception("Failed to update:$e");
}

}

static Future<void>deletetask(String taskid)async{
  try{
  await FirebaseFirestore.instance.collection("Dailytask").doc(taskid).delete();
}
catch(e){
 throw Exception("Failed to Delete :$e");
}
}
static Future<void>updatetask(String taskid,String newtask)async{
  try{
    await FirebaseFirestore.instance.collection("Dailytask").doc(taskid).update({'name':newtask});
  }
  catch(e){
   throw Exception("Failed to update :$e");
  }
}
}