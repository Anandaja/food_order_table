import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/tables.dart';

class OrderDetailsViewModel extends ChangeNotifier {
  List FoodsList = [];
  List<fooddetails> OngoingList = []; //fodddetails or Ongoing order class
  late int Tableno;

  bool isProcessing = false;

  Widget ListCreator(
      BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
    print('is wor ${mapofuserdetails['foodname']}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.27),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            color:
                // Color.fromARGB(255, 247, 247, 247)
                const Color.fromARGB(255, 255, 255, 255),
          ),
          height: MediaQuery.of(context).size.height / 10,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Color.fromARGB(255, 255, 188, 4)
                    // Color.fromRGBO(68, 142, 74, 1),
                    ),
                width: MediaQuery.of(context).size.width / 28,
                //height: MediaQuery.of(context).size.height / 10,
              ),

              const SizedBox(
                width: 15,
              ),
              //used expanded to align elements correctly
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapofuserdetails['foodname'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${mapofuserdetails['rate']} INR',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 188, 4),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    mapofuserdetails['quantity'].toString(),
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 188, 4),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        // child: ListTile(
        //   tileColor: Colors.blueGrey,
        //   title: Text(
        //     mapofuserdetails['foodname'],
        //     style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        //   ),
        //   subtitle: Text(
        //     mapofuserdetails['quantity'].toString(),
        //     style: const TextStyle(color: Colors.yellow),
        //   ),
        // ),
      ),
    );
  }

  Widget ListBilling(BuildContext context,
      {required String foodname,
      required String rate,
      required int quantity,
      required int index,
      required int foodtotal}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(foodname,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      )))),
          Spacer(),
          Text(rate,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      )))),
          Text(' x ${quantity.toString()}',
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      )))),
          Spacer(),
          Text(
            '${foodtotal.toString()}/-',
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ))),
          )
        ],
      ),
    );
  }

  //total rate calculating
  int totalrate({required List<fooddetails> BillFood}) {
    int grandtotal = 0;
    for (fooddetails foodItem in BillFood) {
      String foodName = foodItem.foodname;
      int quantity = foodItem.quantity;
      String rate = foodItem.rate;

      // OrderCart(foodname: foodName, rate: rate, quantity: quantity);
      int result = int.parse(rate) * quantity; //test for the calculation
      grandtotal += result; // Add to grand total
      //   print("order list ${OrderCartList}");
      // print("Foodlist $Foods");
      print("Food rate $result");
      print('Food Name: $foodName');
      print('Quantity: $quantity');
      print('Rate: $rate');
    }
    print("Total rate $grandtotal");
    return grandtotal;
  }

  // void Orderfood(BuildContext context,
  //     {required String uniqeid,
  //     required String foodname,
  //     required String quantinty,
  //     required bool New,
  //     required int? TableNo,
  //     required bool TableAvailability}) {
  //   TableReference.orderByChild('TableNo')
  //       .equalTo(TableNo)
  //       .get()
  //       .then((snapshot) {
  //     if (snapshot.exists) {
  //       Map values = snapshot.value as Map;
  //       values.forEach((key, value) {
  //         String CurrentTableKey =
  //             key; //getting the doc key of selected table number
  //         print('is this is the $CurrentTableKey');
  //         print('value ${value['Availability']}');

  //         TableReference.child(CurrentTableKey).child('Ongoing Order').set({
  //           'uniqeid': uniqeid,
  //           'New': New,
  //           'TableNo': TableNo,
  //           'foods': [
  //             {
  //               'quantity': quantinty,
  //               'foodname': foodname,
  //               'rate': '100',
  //             },
  //             {
  //               'quantity': '1',
  //               'foodname': 'Biriyani',
  //               'rate': '10',
  //             }
  //           ]
  //         }).then((value) {
  //           TableReference.child(CurrentTableKey).update({
  //             'Availability': TableAvailability,
  //           });
  //         }).then((value) {
  //           print('TableAvailability $TableAvailability');
  //           print('New set added');
  //           print('unique id $uniqeid');
  //           print('foodname $foodname');
  //           print('quantity $quantinty');
  //           print('bool  order $New');
  //           print('Table No $TableNo');

  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Text(
  //               'Order Placed',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
  //           ));
  //         }).then((value) => Navigator.of(context).pop());
  //       });
  //     } else {
  //       print('No data available.1');
  //     }
  //   });

  //   //print('Is this correct $docid ');
  // }

  bool isFetching = true;
  void test({required int tableNo}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (OngoingList.isEmpty) {
        //  getOrders();
        await getTableData(tableNo: tableNo);
        isFetching = false;
      }
      notifyListeners();
    });
  }

  void DetailssLoader(BuildContext context, {required int tableNo}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isFetching = true;
        notifyListeners();

        await getTableData(tableNo: tableNo);

        // Set loading state to false
        isFetching = false;
        notifyListeners();
      } catch (e) {
        // Handle errors
        if (kDebugMode) {
          print('Error loading  details: $e');
        }
        // Set loading state to false in case of an error
        isFetching = false;
        notifyListeners();
      }
    });
  }

  final DatabaseReference tableReference =
      FirebaseDatabase.instance.ref().child('tables');

  //fetching data
  Future<void> getTableData({required int? tableNo}) async {
    try {
      DataSnapshot snapshot =
          await tableReference.orderByChild('TableNo').equalTo(tableNo).get();

      // Check if the table exists
      if (snapshot.value == null) {
        print('Table not found');
        return;
      }

      // Accessing the first (and only) table found
      Map tableData = snapshot.value as Map<dynamic, dynamic>;

      // Check if ongoing order exists
      if (tableData.isNotEmpty) {
        dynamic ongoingOrder = tableData.values.first['Ongoing Order'];

        if (ongoingOrder != null) {
          int tableNumber = ongoingOrder['TableNo'];
          // Cast the list to List<fooddetails>
          OngoingList = (ongoingOrder['foods'] as List<dynamic>)
              .map((item) => fooddetails.fromMap(item))
              .toList();

          print('Table Number: $tableNumber');

          // Iterating over each food item
          for (fooddetails foodItem in OngoingList) {
            String foodName = foodItem.foodname;
            int quantity = foodItem.quantity;
            String rate = foodItem.rate;

            print('Food Name: $foodName');
            print('Quantity: $quantity');
            print('Rate: $rate');
          }
        } else {
          print('No ongoing orders for this table');
        }
      } else {
        print('Table not found');
      }
    } catch (e) {
      print('Error while getting data: $e');
    }
  }

  Future<void> ConfirmOrder(BuildContext context,
      {required int tableNo, required bool Availability}) async {
    try {
      await tableReference
          .orderByChild('TableNo')
          .equalTo(tableNo)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          Map values = snapshot.value as Map;
          values.forEach((key, value) {
            String CurrentTableKey =
                key; //getting the doc key of selected table number
            print('is this is the $CurrentTableKey');
            print('value ${value['Availability']}');
            tableReference.child(CurrentTableKey).update({
              'Availability': Availability,
            }).then((value) {
              print('Availibility changed');
              tableReference
                  .child(CurrentTableKey)
                  .child('Ongoing Order')
                  .remove();
            }).then((value) {
              print('Removed ongoing Data from the database');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Order Confirmed',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
              ));
            }).then((value) => Navigator.of(context).pop());
          });
        }
      });
    } catch (e) {
      print('Error when confirming the order $e');
    }
  }
}
