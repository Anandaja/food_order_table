import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/menu.dart';
import 'package:order_now_android/view/widgets/Bounceble.dart';
import 'package:order_now_android/view_model/cartpage_view_medel.dart';
import 'package:provider/provider.dart';

class HomepageuserViewModel extends ChangeNotifier {
  int? dropdownValue;
  List<int> TableList = [1, 2, 3, 4, 5, 6, 7, 8];

  List<String> images = [
    'assets/image/Chicken Biriyani.jpg',
    'assets/image/Ghee rice.jpg',
    'assets/image/Alpham.jpg',
    'assets/image/Peri peri Alpham.jpg'
  ];

//working orders
//old code normal doc adding
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
  //           'foodname': foodname,
  //           'quantinty': quantinty,
  //           'New': New,
  //           'TableNo': TableNo,
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

  DatabaseReference TableReference =
      FirebaseDatabase.instance.ref().child('tables');

  void Orderfood(BuildContext context,
      {required String uniqeid,
      required String foodname,
      required String quantinty,
      required bool New,
      required int? TableNo,
      required bool TableAvailability}) {
    TableReference.orderByChild('TableNo')
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
            'foods': [
              {
                'quantity': quantinty,
                'foodname': foodname,
                'rate': '100',
              },
              {
                'quantity': '1',
                'foodname': 'Biriyani',
                'rate': '10',
              }
            ]
          }).then((value) {
            TableReference.child(CurrentTableKey).update({
              'Availability': TableAvailability,
            });
          }).then((value) {
            print('TableAvailability $TableAvailability');
            print('New set added');
            print('unique id $uniqeid');
            print('foodname $foodname');
            print('quantity $quantinty');
            print('bool  order $New');
            print('Table No $TableNo');

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Order Placed',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
            ));
          }).then((value) => Navigator.of(context).pop());
        });
      } else {
        print('No data available.1');
      }
    });

    //print('Is this correct $docid ');
  }

  //food doc

  void foodDocs(
    BuildContext context, {
    required String foodname,
    required String rate,
    required String catogary,
    required bool isAvailable,
  }) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('menu');

    databaseReference.push().set({
      'foodname': foodname,
      'rate': rate,
      'isAvailable': isAvailable,
      'catogary': catogary,
    }).then((value) {
      print('New set added');
      print('foodname $foodname');
      print('rate $rate');
      print('bool  order $isAvailable');
      print('catogary $catogary');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'New Food Added',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
      ));
    });
  }

  List<MenuDetails> MenuList = [];
  bool isFetching = false;

  void test() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getFoods();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isFetching = true;
        notifyListeners();

        await getFoods();

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

  // final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

//my code
  Future<void> getFoods() async {
    try {
      DataSnapshot snapshot = await databaseReference.child('menu').get();
      // print('TESTTT  ${snapshot.key}');
      final details = snapshot.children
          .map((doc) => MenuDetails.fromMap(doc.value))
          .toList();

      // Update the orderList
      MenuList = details;
      if (kDebugMode) {
        print('length ${MenuList.length}');
      }
      //  print("Order ${MenuList[2].foodname}");
      if (MenuList.isEmpty) {
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

  int? testIndex;

  //int indexfind()
  //return bool if there is any addition on CartList(That made First time)
  bool checkIfAddedToCartList(Map<String, dynamic> fooddetails) {
    // Replace this with your logic to check if the food item is in the cart
    // You might need to compare the 'fooddetails' with items in 'OrderCartList'
    // and return true if it's already present.
    // Example assuming 'OrderCartList' is a List<Map<String, dynamic>>:

    for (var item in CartList) {
      if (item['foodname'] == fooddetails['foodname']) {
        return true;
      }
    }

    return false;
  }

//returns true when there is any addition on OrderCartList of CartpageviewModel
  bool checkIfAddedToOrderCartList(
      Map<String, dynamic> fooddetails, BuildContext context) {
    // Replace this with your logic to check if the food item is in the cart
    // You might need to compare the 'fooddetails' with items in 'OrderCartList'
    // and return true if it's already present.
    // Example assuming 'OrderCartList' is a List<Map<String, dynamic>>:
    final pro = Provider.of<CartPageViewModel>(context, listen: false);
    for (var item in pro.OrderCartList) {
      if (item['foodname'] == fooddetails['foodname']) {
        return true;
      }
    }

    return false;
  }

  bool isAddedToCartList = false;
  bool isAddedToOrderCartList = false;
  Widget GridCreator(
      BuildContext context, Map<String, dynamic> fooddetails, int index) {
    //   String Rate = fooddetails['rate'];
    //print("is availble $Rate");
    print("Image Url ${fooddetails['image']}");
    isAddedToCartList = checkIfAddedToCartList(fooddetails);
    isAddedToOrderCartList = checkIfAddedToOrderCartList(fooddetails, context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Bounceable(
        onTap: () {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => const RoomCreationPage(),
          //   ),
          // );
          //room creation
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.27),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 245, 246, 246),
          ),
          height: MediaQuery.of(context).size.height / 5.3,
          width: MediaQuery.of(context).size.width /
              3.1, //is this both are optional??
          child: IntrinsicHeight(
            //by  doing this our overflow is fixed?
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Color.fromARGB(0, 255, 188, 4),
                  ),
                  width: double.infinity,
                  height: 110, //just added manual height
                  // height: MediaQuery.of(context).size.height     7.6, //7.6 past and set

                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),

                      // Image.asset(
                      //   images[index],
                      //   fit: BoxFit.cover,
                      // ),
                      child: Image.asset(
                        fooddetails['image'],
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      fooddetails['foodname'],
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${fooddetails['rate']} INR',
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 255, 188, 4),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                isAddedToCartList ||
                        isAddedToOrderCartList //checking the new doc is added when first time it will be CartList, the other chance is backing from cart and booking another food
                    ? fooddetails[index] == testIndex
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  print(
                                      'ITEM IS ALREADY ADDED TO CART'); //New food map added to OrderCartList(availble in cartpageView Model)
                                  //happening because of the modification in Adding to cart
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 188, 4)),
                                child: const Text(
                                  'Added',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                    : Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Tooltip(
                            message: 'Add to Cart',
                            child: ElevatedButton(
                              onPressed: () {
                                //we should call the function and get the mapofuserdetails foodname,rate,and quantitiy an new int add these three to an map and
                                // //then to List
                                testIndex = index;
                                AddingToCart(context, fooddetails: fooddetails);
                                print('pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 0, 0)),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List CartList = [];
  bool ButtonVisibility = false;

  Future<void> AddingToCart(BuildContext context,
      {required Map<String, dynamic> fooddetails}) async {
    final provider = Provider.of<CartPageViewModel>(context, listen: false);
    print('foodname ${fooddetails['foodname']}');
    print('rate ${fooddetails['rate']}');
    Map<String, dynamic> FoodDetails =
        {}; //notmal map or string dynamic//check it

    if (provider.OrderCartList.isNotEmpty) {
      bool foodFound = false;

      for (dynamic food in provider.OrderCartList) {
        String foodname = food['foodname'];
//if the food is found then  no need to add it to the list , if its not found  then add to OrderCartlist
        if (foodname == fooddetails['foodname']) {
          print("This foodname is already in this list $foodname");
          foodFound = true;
          break; // No need to continue checking once the food is found
        }
      }

      if (!foodFound) {
        print("The food is not in the list");

        Map<String, dynamic> FoodDetails = {
          'foodname': fooddetails['foodname'],
          'rate': fooddetails['rate'],
          'quantity': 1,
          'image': fooddetails['image']
        };

        provider.OrderCartList.add(FoodDetails);
        // ButtonVisibility = true;
        notifyListeners();
        print('Order Cart List From Home Page ${provider.OrderCartList}');
      }
    } else {
      //add image url from menu to this map so you can get it from the cart page
      FoodDetails.addAll({
        'foodname': fooddetails['foodname'],
        'rate': fooddetails['rate'],
        'quantity': 1,
        'image': fooddetails['image']
      });
      print('foddetails map ${FoodDetails}');
      CartList.add(FoodDetails);
      ButtonVisibility = true; //for the continue button
      notifyListeners();
      print('Cart List ${CartList}');
    }
  }
}
