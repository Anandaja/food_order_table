// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order_now_android/model/tables.dart';
import 'package:order_now_android/view/order_details.dart';
import 'package:order_now_android/view/widgets/Bounceble.dart';

class HomepageViewModel extends ChangeNotifier {
  List<TableDetails> TableList = [];
  List<OngoingOrder> OngoingList = [];

  void test() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  getOrders();
      getTableData();
    });
  }

  // final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

//my code
  Future<void> getOrders() async {
    try {
      DataSnapshot snapshot = await databaseReference
          .child('tables')
          .child('-NoW6l4ME6A9G9pRbH0s')
          .child('Ongoing Order')
          //  .child('foods/0')
          .get();
      print('TESTTT  ${snapshot.value}');
      //you have two option, one is fixing this map conversion to list below(Just add like how you order as list) or Passing the table no to next page and fetching data
      final orderdetails = snapshot.children
          .map((doc) =>
              OngoingOrder.fromMap(snapshot.value as Map<String, dynamic>))
          .toList();

      // Update the orderList
      OngoingList = orderdetails;
      if (kDebugMode) {
        print('length ${OngoingList.length}');
      }
      //   print("Order ${OrderList[2].foodname}");
      if (OngoingList.isEmpty) {
        if (kDebugMode) {
          print('List empty no orders');
        }
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting data $e');
      }
    }
  }

  //get tables data
  Future<void> getTableData() async {
    try {
      DataSnapshot snapshot = await databaseReference.child('tables').get();

      // print('TESTTT  ${snapshot.key}');
      final tabledetails = snapshot.children
          .map((doc) => TableDetails.fromMap(doc.value))
          .toList();

      // Update the TableList
      TableList = tabledetails;
      if (kDebugMode) {
        print('length ${TableList.length}');
      }
      // print("Table no  ${TableList[2].TableNo}");
      if (TableList.isEmpty) {
        if (kDebugMode) {
          print('List empty no orders');
        }
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting data $e');
      }
    }
  }

  Widget ListCreator(
      BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        tileColor: Colors.blueGrey,
        title: Text(
          mapofuserdetails['foodname'],
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        subtitle: Text(
          mapofuserdetails['quantinty'],
          style: const TextStyle(color: Colors.yellow),
        ),
      ),
    );
  }

  bool Availbility = false;

  Widget Creator(
      BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
    Availbility = mapofuserdetails['Availability'];
    //  print('object ${mapofuserdetails['Ongoing Order']}');

    return Padding(
      padding: const EdgeInsets.all(15), //15 or 10
      child: Bounceable(
        onTap: () {
          //  print('object ${mapofuserdetails['Ongoing Order']['foods']}');
          //  print('object ${mapofuserdetails['Ongoing Order']}');
          if (mapofuserdetails['Availability'] == false) {
            print('Table Availbility ${mapofuserdetails['Availability']}');
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CurrentTableDetails(
                        currentOrderData: mapofuserdetails)));
          } else {
            print('Table Availbility ${mapofuserdetails['Availability']}');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Availbility
                ? Color.fromARGB(255, 238, 238, 238)
                : Color.fromARGB(255, 255, 188, 4),
            //Color.fromARGB(255, 68, 142, 74) or this green??
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              Availbility
                  ? const BoxShadow(
                      color: Color.fromARGB(0, 0, 0, 0),
                    )
                  : const BoxShadow(
                      color: Color.fromARGB(47, 0, 0, 0),
                      blurRadius: 4.0,
                      spreadRadius: 0,
                      offset: Offset(
                        3,
                        4,
                      ),
                    )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Availbility
                  ? SizedBox(
                      height: 58,
                      width: 58,
                      child: Image.asset(
                        'assets/image/nothing.png',
                        fit: BoxFit.contain,
                      ))
                  : SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        'assets/animation/Shaking Bag.json',
                        frameRate: FrameRate(60),
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
              Spacer(),
              Text(
                'Table no ${mapofuserdetails['TableNo'].toString()}',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: GestureDetector(
    //     onTap: () {
    //       // print('object ${mapofuserdetails['Ongoing Order']['foods']}');
    //       print('object ${mapofuserdetails['Ongoing Order']}');
    //       if (mapofuserdetails['Availability'] == false) {
    //         print('Table Availbility ${mapofuserdetails['Availability']}');
    //         Navigator.push(
    //             context,
    //             CupertinoPageRoute(
    //                 builder: (context) => CurrentTableDetails(
    //                     currentOrderData: mapofuserdetails)));
    //       } else {
    //         print('Table Availbility ${mapofuserdetails['Availability']}');
    //       }
    //     },
    //     child: ListTile(
    //       tileColor: Availbility ? Colors.blueGrey : Colors.redAccent,
    //       title: Text(
    //         mapofuserdetails['TableNo'].toString(),
    //         style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    //       ),
    //       subtitle: Text(
    //         mapofuserdetails['Availability'].toString(),
    //         style: const TextStyle(color: Colors.yellow),
    //       ),
    //     ),
    //   ),
    // );
  }
}
