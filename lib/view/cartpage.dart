// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:order_now_android/view_model/cartpage_view_medel.dart';
import 'package:order_now_android/view_model/homepageuser_view_model.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage(
      {this.TestIfthere,
      super.key,
      required this.FoodList,
      required this.TABLENO});

  final List FoodList;
  final int? TABLENO;
  final bool? TestIfthere;

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  // void AddingMapToList

  // void iniState() {
  //   print("Passed List ${widget.FoodList}");
  //   super.initState();
  // }
  Dilog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ALert"),
        content: const Text("If you go back , cart will be discarded"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<CartPageViewModel>(context, listen: false)
                  .OrderCartList
                  .clear();
              Provider.of<CartPageViewModel>(context, listen: false)
                  .FoodsList
                  .clear();
              Navigator.of(context).pop();
            },
            child: const Text("okay"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CartPageViewModel>(context, listen: false).DetailssLoader(
        context,
        foodlist: widget.FoodList,
        isRepeat: widget.TestIfthere!);
    print("Passed List ${widget.FoodList}");
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // is it Works? // for the back button in mobile
        Provider.of<HomepageuserViewModel>(context, listen: false).test();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: MediaQuery.of(context).size.height / 6,
        //   centerTitle: true,
        //   title: const Text(
        //     'Order Details',
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 25,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   leading: IconButton(
        //     onPressed: () {
        //       if (Provider.of<CartPageViewModel>(context, listen: false)
        //           .OrderCartList
        //           .isEmpty) {
        //         print("From the icon button of cart details");
        //         Navigator.of(context).pop();
        //       } else {
        //         Dilog();
        //       }

        //       // Provider.of<CartPageViewModel>(context, listen: false)
        //       //     .OrderCartList
        //       //     .clear();
        //       // Provider.of<CartPageViewModel>(context, listen: false)
        //       //     .FoodsList
        //       //     .clear();
        //       // // Navigator.of(context).pop();
        //       // Navigator.of(context).pop(
        //       //     Provider.of<CartPageViewModel>(context, listen: false)
        //       //         .OrderCartList);
        //     },
        //     icon: SizedBox(
        //       height: 15,
        //       width: 15,
        //       child: Image.asset(
        //         'assets/images/left-arrow.png',
        //         //alignment: Alignment.topCenter,
        //         fit: BoxFit.contain,
        //       ),
        //     ),
        //   ),
        //   backgroundColor: Colors.transparent,
        // ),
        body: Consumer<CartPageViewModel>(builder: (context, consumer, child) {
          return CustomScrollView(slivers: [
            SliverAppBar(
              centerTitle: true,
              toolbarHeight: MediaQuery.of(context).size.height / 6,
              title: const Text(
                'Order Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  print(
                      " Cart List Of Homepage${Provider.of<HomepageuserViewModel>(context, listen: false).CartList}");
                  Navigator.of(
                    context,
                  ).pop([
                    Provider.of<HomepageuserViewModel>(context, listen: false)
                        .test() //for the quick load after Item remove from cart , then
                    //avilble on the Home page
                  ]);

                  // Provider.of<CartPageViewModel>(context, listen: false)
                  //     .OrderCartList
                  //     .clear();
                  // Provider.of<CartPageViewModel>(context, listen: false)
                  //     .FoodsList
                  //     .clear();
                  // // Navigator.of(context).pop();
                  // Navigator.of(context).pop(
                  //     Provider.of<CartPageViewModel>(context, listen: false)
                  //         .OrderCartList);
                },
                icon: SizedBox(
                  height: 15,
                  width: 15,
                  child: Image.asset(
                    'assets/image/left-arrow.png',
                    //alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       SizedBox(
            //         //should we remove this sized ox and add sliver app bar there is it good?
            //         width: double.infinity,
            //         height: MediaQuery.of(context).size.height / 6,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 15),
            //           child: Row(
            //             // mainAxisAlignment: MainAxisAlignment.start,
            //             //   crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               IconButton(
            //                 onPressed: () {
            //                   if (Provider.of<CartPageViewModel>(context,
            //                           listen: false)
            //                       .OrderCartList
            //                       .isEmpty) {
            //                     print("From the icon button of cart details");
            //                     Navigator.of(context).pop();
            //                   } else {
            //                     Dilog();
            //                   }

            //                   // Provider.of<CartPageViewModel>(context, listen: false)
            //                   //     .OrderCartList
            //                   //     .clear();
            //                   // Provider.of<CartPageViewModel>(context, listen: false)
            //                   //     .FoodsList
            //                   //     .clear();
            //                   // // Navigator.of(context).pop();
            //                   // Navigator.of(context).pop(
            //                   //     Provider.of<CartPageViewModel>(context, listen: false)
            //                   //         .OrderCartList);
            //                 },
            //                 icon: SizedBox(
            //                   height: 15,
            //                   width: 15,
            //                   child: Image.asset(
            //                     'assets/images/left-arrow.png',
            //                     //alignment: Alignment.topCenter,
            //                     fit: BoxFit.contain,
            //                   ),
            //                 ),
            //               ),
            //               Spacer(),
            //               const Text(
            //                 'Order Details',
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 25,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //               Spacer()
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(10), //should we reomove from the top
            //   child: Stack(children: [
            //     consumer.isFetching
            //         ? const CircularProgressIndicator()
            //         : widget.FoodList.isEmpty
            //             ? const Center(
            //                 child: Text(
            //                     'You havent added any food')) //if passed list is empty
            //             : SliverList( //its not sliverlist its actaually an listview buildr
            //                 delegate: SliverChildBuilderDelegate(
            //                   (BuildContext context, int index) {
            //                     // Use a bool if All chip is selected, then automatically load the data on this page
            //                     Map<String, dynamic> detailsList = {
            //                       'foodname': consumer.FoodsList[index].foodname,
            //                       'quantity': consumer.FoodsList[index].quantity,
            //                       'rate': consumer.FoodsList[index].rate,
            //                       // Get the image URL from here, from the map of the list passed from the home page
            //                     };
            //                     return consumer.Tile(context, detailsList, index);
            //                   },
            //                   childCount: consumer.FoodsList.length,
            //                 ),
            //               ),
            //   ]),
            // ),
            consumer.isFetching
                ? SliverToBoxAdapter(
                    child: Center(
                        child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Lottie.asset(
                      'assets/animation/Loading animation.json',
                      //   repeat: false,
                      fit: BoxFit.contain,
                    ),
                  )))
                : widget.FoodList.isEmpty
                    ? const SliverFillRemaining(
                        hasScrollBody: true,
                        //  fillOverscroll: true,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('You haven\'t added any food')))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // Use a bool if All chip is selected, then automatically load the data on this page
                            Map<String, dynamic> detailsList = {
                              'foodname': consumer.FoodsList[index].foodname,
                              'quantity': consumer.FoodsList[index].quantity,
                              'rate': consumer.FoodsList[index].rate,
                              'image': consumer.FoodsList[index].image
                              // Get the image URL from here, from the map of the list passed from the home page
                            };
                            return consumer.Tile(context, detailsList, index);
                          },
                          childCount: consumer.FoodsList.length,
                        ),
                      ),

            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  consumer.OrderCartList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 13,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    "The CART LIST FROM BILL section:::: ${consumer.OrderCartList}");
                                //load the bill
                                // List test = consumer.RemoveUrL(consumer.OrderCartList);
                                // print("Url removed List $test");
                                consumer.LoadBill(context,
                                    consumer.OrderCartList, widget.TABLENO);
                                //consumer.fetchingdata(BillFood: consumer.OrderCartList);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 37, 37, 37)),
                              child: Text("Place Order",
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)))),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ]);
        }),
      ),
    );
  }
}
