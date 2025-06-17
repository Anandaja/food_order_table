import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:order_now_android/view/cartpage.dart';
import 'package:order_now_android/view_model/cartpage_view_medel.dart';
import 'package:order_now_android/view_model/homepageuser_view_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class BookingStatusScreen extends StatefulWidget {
  final String userId;
  final String formattedDate;
  final int tableNumber;
  final String? selectedTime;

  const BookingStatusScreen({
    super.key,
    required this.userId,
    required this.formattedDate,
    required this.tableNumber,
    required this.selectedTime,
  });

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  late DocumentReference bookingRef;
  late StreamSubscription<DocumentSnapshot> _bookingSubscription;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    bookingRef = FirebaseFirestore.instance
        .collection("bookings")
        .doc(widget.formattedDate)
        .collection("table_${widget.tableNumber}")
        .doc(widget.selectedTime);

    _bookingSubscription = bookingRef.snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data != null && !_hasNavigated) {
        String status ='pending';
        debugPrint("Status updated: $status");

        if (status == 'approved') {
          _hasNavigated = true;
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyHomePageuser(tableNO: widget.tableNumber),
              ),
            );
          }
        } else if (status == 'rejected') {
          _hasNavigated = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your booking was rejected.'),
              backgroundColor: Colors.red,
            ),
          );
          if (mounted) Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _bookingSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/Loading animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Waiting for table approval...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}



class MyHomePageuser extends StatefulWidget {
  const MyHomePageuser({super.key, required this.tableNO});

  final int? tableNO;

  @override
  State<MyHomePageuser> createState() => _MyHomePageuserState();
}

class _MyHomePageuserState extends State<MyHomePageuser> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();
  TextEditingController Quantitycontroller = TextEditingController();
  String generateUniqueID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  void updateData(String companyname, String Address) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('orders');

    databaseReference.update({
      "Company Name": companyname,
      "Address": Address,
    }).then((value) => print('data updated to $companyname and $Address'));
  }

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
      'foodname': foodname.toString(),
      'rate': rate.toString(),
      'isAvailable': isAvailable  ,
      'category': catogary.toString(),
    }).then((value) {
      print('New set added');
      print('foodname $foodname');
      print('rate $rate');
      print('bool  order $isAvailable');
      print('category $catogary');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'New Food Added',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: (Color.fromARGB(255, 0, 0, 0)),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomepageuserViewModel>(context, listen: false).test();
    return Scaffold(
    
      body: Consumer<HomepageuserViewModel>(builder: (context, consumer, child) {
        return Stack(children: [
          consumer.isFetching
              ? Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Lottie.asset(
                      'assets/animation/Loading animation.json',
                      //   repeat: false,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'ORDER',
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    height: 9,
                                    width: 9,
                                    // margin: EdgeInsets.all(100.0),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFFBD04),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                const SizedBox(
                                  width: 3.5,
                                ),
                                const Text(
                                  'NOW',
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Color(0xFFFFBD04),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Recommended',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        // childAspectRatio: MediaQuery.of(context).size.width /
                        //     (MediaQuery.of(context).size.height / 1.8),
                        crossAxisCount: 2,
                        mainAxisSpacing: 28.0,
                        crossAxisSpacing: 0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Map<String, dynamic> detailsList = {
                            'foodname': consumer.MenuList[index].foodname,
                            'rate': consumer.MenuList[index].rate,
                            'isAvailable': consumer.MenuList[index].isAvailable ,
                            'category': consumer.MenuList[index].catogary,
                            'image': consumer.MenuList[index].image
                          };
                          return consumer.GridCreator(
                              context, detailsList, index);
                        },
                        childCount: consumer.MenuList.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          consumer.ButtonVisibility //only when any item  added to cart
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: GestureDetector(
                                        onTap: () {
                                          final provider =
                                              Provider.of<CartPageViewModel>(
                                                  context,
                                                  listen: false);
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => CartPage(
                                                      TestIfthere: provider
                                                          .OrderCartList
                                                          .isNotEmpty, //returns true
                                                      FoodList: provider
                                                              .OrderCartList
                                                              .isEmpty
                                                          ? consumer.CartList
                                                          : provider
                                                              .OrderCartList,
                                                      TABLENO: widget.tableNO,
                                                    )),
                                          ).then((value) {
                                            // setState(() {
                                            //   consumer.isAddedToCart = false;
                                            // });
                                            // consumer.CartList
                                            //     .clear(); //clearing the list after passing it for avoiding document multiplication
                                          });
                                          print('Tapped ');
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.27),
                                                blurRadius: 4,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              //SizedBox(width: 7,),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(9),
                                                    bottomLeft:
                                                        Radius.circular(9),
                                                  ),
                                                  color: Color.fromARGB(
                                                      0, 255, 255, 255),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    9,
                                                // child: ClipRRect(
                                                //   borderRadius: const BorderRadius.only(
                                                //     topLeft: Radius.circular(9),
                                                //     bottomLeft: Radius.circular(9),
                                                //   ),
                                                //   child: Center(
                                                //     child: Image.asset(
                                                //         'assets/images/cart.png',
                                                //         width: MediaQuery.of(context)
                                                //                 .size
                                                //                 .width /
                                                //             11,
                                                //         height: MediaQuery.of(context)
                                                //                 .size
                                                //                 .height /
                                                //             11),
                                                //   ),
                                                // ),
                                              ),
                                              //used expanded to align elements correctly

                                              const Text(
                                                'View Order',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(9),
                                                    bottomRight:
                                                        Radius.circular(9),
                                                  ),
                                                  color: Color.fromARGB(
                                                      255, 179, 230, 193),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(9),
                                                    bottomLeft:
                                                        Radius.circular(9),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                        'assets/image/cart.png',
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            11,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            11),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ]);
      }),
    );
  }
}
