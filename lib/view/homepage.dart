// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/view/admin_approval.dart';
import 'package:order_now_android/view/menu.dart';
import 'package:order_now_android/view_model/homepage_view_model.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('tables');

  final FlutterTts flutterTts = FlutterTts();

  Future<void> FetchingData() async {
    databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      snapshot.children.forEach((element) {
        // Access data for each order
        //  dynamic orderData = element.value as Map<String, dynamic>;
        String? orderId = element.key; // Get the automatically generated ID
        print('Order ID: $orderId');
        // print('Food name: ${orderData['foodname']}');
        // print('Quantity: ${orderData['quantinty']}');
        // Access other fields as needed
      });
    });
  }

  @override
  void initState() {
    Testload();
    FetchingData(); //to get all doc id
   
    super.initState();
  }

  Future<void> initializeTTS() async {
    // Perform TTS initialization and setup here
    await flutterTts.awaitSpeakCompletion(true);
  }

  // bool isFirstLoad = true;
  Future<void> Testload() async {
    // Listen for child added events
    databaseReference.onChildChanged.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> orderData =
            event.snapshot.value as Map<dynamic, dynamic>;

        print('New document added with ID: ${event.snapshot.key}');

        print("New Doc data ${event.snapshot.value}");
        setState(() {
          //optional!!!!
          orderData['foodname'];
          orderData['quantity'];
        });

        if (orderData['Availability'] == false) {
          //  i think i should update the table bool here
          await initializeTTS();
          flutterTts.speak('ORDER RECEIVED').then((result) {
            if (result == 1) {
              print("TTS success");
            } else {
              print("TTS error: $result");
            }
          });
        } else {
          print('No sound');
        }
      }
    }, onError: (Object error) {
      print('Error: $error');
    });

  
  }

  //conctivity check



  @override
  Widget build(BuildContext context) {
    Provider.of<HomepageViewModel>(context, listen: false)
        .test(); //while call it here it prints the lenght or anything two times,by moving it to another place it not happaing
    return Scaffold(
      body: Consumer<HomepageViewModel>(builder: (context, consumer, child) {
        return Stack(children: [
          
               CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true, //its alwys align in centre
                      toolbarHeight: MediaQuery.of(context).size.height / 7,
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            ' Here',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 188, 4),
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          )
                        ],
                        
                      ),

                       actions: [
                  IconButton(
                    icon:
                        const Icon(Icons.add_comment, color: Colors.black),
                    tooltip: 'Manage Menu',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminBookingApprovalPage(),
                        ),
                      );
                    },
                  ),
    IconButton(
      icon: const Icon(Icons.restaurant_menu, color: Colors.black),
      tooltip: 'Manage Menu',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminMenuPage(),
          ),
        );
      },
    ),
  ],
  floating: true,
  pinned: true,

                    ),
                    SliverGrid(

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.9, //for adjusting the size
                  
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 0, // spacing between rows
                        crossAxisSpacing: 0, // spacing between columns
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Map<String, dynamic> detailsList = {
                            'TableNo': consumer.TableList[index].TableNo,
                            'Availability':
                                consumer.TableList[index].Availability,
                            'Ongoing Order':
                                consumer.TableList[index].Ongoingord
                          };
                          // print(
                          //     "NO ${detailsList.values} + Availbility ${detailsList['Availability']}");
                          return consumer.Creator(context, detailsList, index);
                        },
                        childCount: consumer.TableList.length,
                      ),
                    ),
                  ],
                ),
        ]);

       
      }),
     
    );
  }
}
