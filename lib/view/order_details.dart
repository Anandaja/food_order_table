// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:order_now_android/view_model/order_details_view_model.dart';
import 'package:provider/provider.dart';

class CurrentTableDetails extends StatefulWidget {
  const CurrentTableDetails({super.key, required this.currentOrderData});

  final Map<String, dynamic> currentOrderData;

  @override
  State<CurrentTableDetails> createState() => CurrentTableDetailsState();
}

class CurrentTableDetailsState extends State<CurrentTableDetails> {
  //conctivity check



 

  @override
  void initState() {
    final provider = Provider.of<OrderDetailsViewModel>(context, listen: false);

    provider.Tableno = widget.currentOrderData['Ongoing Order'][
        'TableNo']; //late initialised value adds outside of the post frame call back




    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderDetailsViewModel>(context, listen: false).DetailssLoader(
        context,
        tableNo: widget.currentOrderData['Ongoing Order']['TableNo']);
    return Scaffold(
     
      body:
          Consumer<OrderDetailsViewModel>(builder: (context, consumer, child) {
        return Stack(children: [
        
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true, //its alwys align in centre
                      toolbarHeight: MediaQuery.of(context).size.height / 7,
                      title: Text(
                        'Table no ${consumer.Tableno}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
                    consumer.isFetching
                        ? SliverToBoxAdapter(child: Container())
                        : const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(left: 23, bottom: 6),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Order Details',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                        : consumer.OngoingList.isEmpty
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
                                      'foodname':
                                          consumer.OngoingList[index].foodname,
                                      'quantity':
                                          consumer.OngoingList[index].quantity,
                                      'rate': consumer.OngoingList[index].rate,
                                      //  'uniqeid': consumer.OrderList[index].uniqeid,
                                    };
                                    //  print('Length detailslist ${detailsList.length}');
                                    return consumer.ListCreator(
                                        context, detailsList, index);
                                  },
                                  childCount: consumer.OngoingList.length,
                                ),
                              ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                          
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Bill Details',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2.7,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color.fromARGB(255, 37, 37, 37),
                                // color: Color.fromARGB(255, 255, 188, 4)
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: consumer.OngoingList.length,
                                        itemBuilder: ((context, index) {
                                          //  String foodname = '';
                                          //use a bool if All chip is selected then automatically load the data on this page
                                          // Access the values directly from BillingList[index]
                                          String foodname = consumer
                                              .OngoingList[index].foodname;
                                          int quantity = consumer
                                              .OngoingList[index].quantity;
                                          String rate =
                                              consumer.OngoingList[index].rate;
                                          int foodTotal =
                                              int.parse(rate) * quantity;

                                          print(
                                              'Testt ${consumer.OngoingList}');
                                          return consumer.ListBilling(context,
                                              foodname: foodname,
                                              rate: rate,
                                              quantity: quantity,
                                              index: index,
                                              foodtotal: foodTotal);
                                        }),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 188, 4),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          // style: const TextStyle(
                                          //   color: Color.fromARGB(255, 255, 188, 4),
                                          //   fontWeight: FontWeight.w700,
                                          //   fontSize: 24,
                                          // ),
                                        ),
                                        Text(
                                          '${consumer.totalrate(BillFood: consumer.OngoingList)}/-',
                                          style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 188, 4),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 13,
                              child: ElevatedButton(
                                onPressed: consumer.isProcessing
                                    ? null
                                    : () async {
                                        try {
                                          consumer.ConfirmOrder(context,
                                              tableNo: consumer.Tableno,
                                              Availability: true);
                                        } catch (e) {
                                          print('error on onpressed $e');
                                        } finally {
                                          consumer.isProcessing = false;
                                        }
                                        //confirm order by updating the bool first and then remove ongoing order from this table
                                      },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 37, 37, 37)),
                                child: Center(
                                  child: consumer.isProcessing
                                      ? const SizedBox(
                                          height: 17,
                                          width: 17,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color:
                                                Color.fromRGBO(253, 186, 63, 1),
                                          ),
                                        )
                                      : const Text('Confirm Order',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ]);
      
      }),
    );
  }
}
