import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class LandingpageViewModel extends ChangeNotifier {
  int? dropdownValue;
  List<int> TableList = [];
  bool isEmpty = false;

//function need

  final DatabaseReference tableReference =
      FirebaseDatabase.instance.ref().child('tables');

  //get tables data
  Future<void> getTableData() async {
    try {
      DataSnapshot snapshot =
          await tableReference.orderByChild('Availability').equalTo(true).get();
      //print("value?? ${snapshot.value}");
      print('Drop down Value ${dropdownValue}');
      dropdownValue = null;
      TableList.clear(); //to avoid the duplicate adding
      notifyListeners();
      print('After clear drop down value $dropdownValue');

      snapshot.children.forEach((element) {
        // print("inside ${snapshot.value}");
        int tableno = element.child('TableNo').value as int;
        TableList.add(tableno);
        print("Table no $tableno");
      });
      print("List $TableList");

      if (TableList.isEmpty) {
        print("List IS EMPTY");
        isEmpty = true;
        notifyListeners();
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting data $e');
      }
    }
  }
}
