//import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/order_details.dart';
import 'package:order_now_android/view/confirmpage.dart';
import 'package:order_now_android/view_model/homepageuser_view_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartPageViewModel extends ChangeNotifier {
  //just for ordering purpose
  String generateUniqueID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  // void test({required List foodlist}) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (FoodsList.isEmpty) {
  //       //  getOrders();
  //       await ListToMap(foodlist: foodlist);
  //     }
  //     notifyListeners();
  //   });
  // }

  bool isFetching = false;

  void DetailssLoader(BuildContext context,
      {required List foodlist, required bool isRepeat}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isFetching = true;
        notifyListeners();

        await ListToMap(foodlist: foodlist, isRepeat: isRepeat);
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

//showing the dats from home page as list
  List<fooddetails> FoodsList = [];
  Future<void> ListToMap(
      {required List foodlist, required bool isRepeat}) async {
    //
    FoodsList = foodlist.map((item) => fooddetails.fromMap(item)).toList();
    notifyListeners();
    // print("Foodlist $Foods");
    for (fooddetails foodItem in FoodsList) {
      String foodName = foodItem.foodname;
      int quantity = foodItem.quantity;
      String rate = foodItem.rate;
      String image = foodItem.image;

      OrderCart(
        foodname: foodName,
        rate: rate,
        quantity: quantity,
        image: image,
        isRepeat: isRepeat,
      );

      print("order list ${OrderCartList}");
      // print("Foodlist $Foods");
      print('Food Name: $foodName');
      print('Quantity: $quantity');
      print('Rate: $rate');
    }
  }

  List OrderCartList = [];
  bool isProcessing = false; //for orderNow onpresed

//converting the datas like foodname,rate,quantity to map then to list, then this OrderCartList add to the database while ordering foood
  Future<void> OrderCart(
      {required bool isRepeat,
      required String foodname,
      required String rate,
      required int quantity,
      required String image}) async {
    print('foodname $foodname');
    print('rate ${rate}');
    print('quantity  $quantity');

    if (isRepeat == true) {
      //by checking this we can resolve the doubling issue
      print('No doubling Needed');
      print('Updated Cart List ${OrderCartList}');
      notifyListeners();
    } else {
      Map<String, dynamic> FoodDetails = {};
      FoodDetails.addAll({
        'foodname': foodname,
        'rate': rate,
        'quantity': quantity,
        'image': image
      });
      print('foddetails map ${FoodDetails}');
//    OrderCartList.insert(0, {'q': 1});
      OrderCartList.add(FoodDetails);
      notifyListeners();
      print('New Cart List ${OrderCartList}');
    }
  }

  //counters

  void _incrementCounter(
    int index,
  ) {
    FoodsList[index].quantity++;
    //counter++;

    print("New object ${FoodsList[index].quantity}");
    // FoodsList.insert(
    //     index, FoodsList[index].quantity as fooddetails); //insert from here
    updateOrderCartList(FoodsList[index].quantity, index);

    notifyListeners();
  }

//there is some problme with this counters//to update the create method correctly should we conver to this anint function and add it from the on pressed of the add + and  - respectively
  void _decrementCounter(int index, int Currentquantity,
      Map<String, dynamic> fooddetails, BuildContext context) {
    if (Currentquantity >
        1) //by checking like this when the next quantity is 0 the item will remove from the List
    {
      //print('current Quntity $Currentquantity');
      FoodsList[index].quantity--;
      updateOrderCartList(FoodsList[index].quantity, index);
      notifyListeners();
      print("New object ${FoodsList[index].quantity}");
    } else {
      print("Index $index");
      // print('current Quntity $Currentquantity');
      RemovingfromCartListHome(
          context, fooddetails); //removing item from cart List of Home page
      FoodsList.removeAt(index);
      OrderCartList.removeAt(
          index); //while making it zero and ordering the food it creates more food doc in database ,is there is any other method to do it?

      notifyListeners();
    }
    // if (NewQuantity == 0) {

    // }
    //counter++;
  }

// removing from the cart list of homepage view model
  void RemovingfromCartListHome(
      BuildContext context, Map<String, dynamic> fooddetails) {
    final pro = Provider.of<HomepageuserViewModel>(context, listen: false);
    final index1 = pro.CartList.indexWhere(
        (element) => element["foodname"] == fooddetails['foodname']);

    if (index1 != -1) {
      pro.CartList.removeAt(index1);
      notifyListeners();
      print("Item removed. Now Cart List ${pro.CartList}");
      print("The index in Cart List is $index1");
    } else {
      print("Item not found in CartList");
    }
  }

  void updateOrderCartList(int updatedQuantity, int index) {
    print("quantii $updatedQuantity");
    print('index inside function $index');
    // OrderCartList.insert(index, {'quantity': updatedQuantity});
    Map<String, dynamic> existingCartItem = OrderCartList[index];
    existingCartItem['quantity'] = updatedQuantity;
    print("New Updated Order Cart list ${existingCartItem}");
    notifyListeners();
  }

  Widget Tile(
      BuildContext context, Map<String, dynamic> fooddetails, int index) {
    print('quantityi ${fooddetails['quantity']}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () {
            var result = int.parse(fooddetails['rate']) *
                fooddetails['quantity']; //test for the calculation
            print('total $result');
            print("INDEX $index");
          },
          child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(9),
                color: Color.fromARGB(255, 245, 246, 246)),
            height: MediaQuery.of(context).size.height / 8,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      //  color: Color.fromRGBO(68, 142, 74, 1),
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 8,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        fooddetails['image'],
                        fit: BoxFit.cover, //contain??//fill??
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fooddetails['foodname'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${fooddetails['rate']} INR',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 188, 4),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Column(
                    //      crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Am the index $index");
                          _incrementCounter(index);
                          //  can we use the index to update the particular tile
                          print('Incriment');
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Color.fromARGB(255, 255, 188, 4),
                          ),
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 15,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        fooddetails['quantity'].toString(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 188, 4),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _decrementCounter(index, fooddetails['quantity'],
                              fooddetails, context);
                          print('Decrement');
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Color.fromARGB(255, 245, 246, 246),
                          ),
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.remove,
                                size: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bill
  ///

  int fetchingdata({required List BillFood}) {
    int grandtotal = 0;
    for (dynamic foodItem in BillFood) {
      String foodName = foodItem['foodname'];
      int quantity = foodItem['quantity'];
      String rate = foodItem['rate'];

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

  Widget ListBilling(BuildContext context,
      {required String foodname,
      required String rate,
      required int quantity,
      required int index,
      required int foodtotal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
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
      ),
    );
  }

//for the top of bottom sheet
  Widget _modalBar(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }

  Future LoadBill(BuildContext context, List BillingList, int? tableNo) {
    return showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 37, 37, 37),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)), //for the round edges
      builder: (context) {
        return Column(
          children: [
            _modalBar(context),
            Expanded(
              child: ListView.builder(
                itemCount: BillingList.length,
                itemBuilder: ((context, index) {
                  //  String foodname = '';
                  //use a bool if All chip is selected then automatically load the data on this page
                  // Access the values directly from BillingList[index]
                  String foodname = BillingList[index]['foodname'];
                  int quantity = BillingList[index]['quantity'];
                  String rate = BillingList[index]['rate'];
                  int foodTotal = int.parse(rate) * quantity;

                  print('Testt ${BillingList}');
                  return ListBilling(context,
                      foodname: foodname,
                      rate: rate,
                      quantity: quantity,
                      index: index,
                      foodtotal: foodTotal);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 188, 4))),
                  ),
                  Text(
                    "${fetchingdata(BillFood: OrderCartList)}/-",
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 188, 4))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 13,
                child: ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          //conforming the order
                          String uniqeid = generateUniqueID();
                          //try to setup the booking.
                          // List Foodss =
                          try {
                            isProcessing = true;
                            notifyListeners();

                            await Orderfood(context,
                                uniqeid: uniqeid,
                                New: true,
                                TableNo: tableNo,
                                TableAvailability: false,
                                foodlist: RemoveUrL(OrderCartList));
                          } catch (e) {
                            print("Error from OrderNow Onpressed $e");
                          } finally {
                            isProcessing = false;
                            notifyListeners();
                            //we are not currently used the isProcessing on any were on the other
                          }
                        },
                  child: Text("Order Now",
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 0, 0)))),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
      context: context,
      // isDismissible: //boolean if you want to be able to dismiss it
      // isScrollControlled: //boolean if something does not display, try that
    );
  }

//removing the image Url from each map , then uploading it t
  List RemoveUrL(List Urllist) {
    return Urllist.map((map) {
      map.remove('image');
      return map;
    }).toList();
  }

//tables collection
  DatabaseReference TableReference =
      FirebaseDatabase.instance.ref().child('tables');
//ordering food addig doc to currosponding table
  Future<void> Orderfood(BuildContext context,
      {required String uniqeid,
      required bool New,
      required int? TableNo,
      required bool TableAvailability,
      required List foodlist}) async {
    await TableReference.orderByChild('TableNo')
        .equalTo(TableNo)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        Map values = snapshot.value as Map;
        values.forEach((key, value) {
          String CurrentTableKey =
              key; //getting the doc key of selected table number
          print('is this is the $CurrentTableKey');
          print('value ${value['Availability']}');

          TableReference.child(CurrentTableKey).child('Ongoing Order').set({
            'uniqeid': uniqeid,
            'New': New,
            'TableNo': TableNo,
            'foods': foodlist
          }).then((value) {
            TableReference.child(CurrentTableKey).update({
              'Availability': TableAvailability,
            });
          }).then((value) {
            print('TableAvailability $TableAvailability');
            print('New set added');
            print('unique id $uniqeid');
            print("foodlist $foodlist");
            print("Foodlist length  ${foodlist.length}");
            print('bool  order $New');
            print('Table No $TableNo');

            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //   content: Text(
            //     'Order Placed',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
            // ));

            OrderCartList.clear();
            FoodsList.clear();
            Provider.of<HomepageuserViewModel>(context, listen: false)
                .CartList
                .clear();
            Provider.of<HomepageuserViewModel>(context, listen: false)
                .ButtonVisibility = false;
            // Provider.of<HomepageuserViewModel>(context, listen: false)
            //     .isAddedToCartList = false; ITS TO AVOID THE DISPLAY of Added on gridtile
            // Provider.of<HomepageuserViewModel>(context, listen: false)
            //     .isAddedToOrderCartList = false;
            Navigator.of(context).pop(); //to pop the bottom sheet
          }).then((value) {
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(builder: (context) => ConfirmPage()),
            // );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => ConfirmPage()),
                (route) => false);
          });
        });
      } else {
        print('No data available.1');
      }
    });

    //print('Is this correct $docid ');
  }
}
