import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view/homepage_user.dart';
import 'package:order_now_android/view_model/landing_page_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  bool visibility = false;
  List<String> TextsList = ['We', 'Deliver', 'Fresh food'];

  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  bool showTimeDropdown = false;

  List<String> presetTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '03:00 PM',
    '05:00 PM',
    '07:00 PM',
    '09:00 PM'
  ];
  List<String> availableTimes = [];
  List<String> bookedTimes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LandingpageViewModel>(context, listen: false).getTableData();
    });
  }

  Future<List<String>> fetchBookedTimes(String date, int tableNo) async {
    final snap = await FirebaseFirestore.instance
        .collection("bookings")
        .doc(date)
        .collection("table_$tableNo")
        .get();

    return snap.docs.map((doc) => doc.id).toList();
  }

  void loadAvailableTimes(int tableNo, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    bookedTimes = await fetchBookedTimes(formattedDate, tableNo);
    print("Booked Times: $bookedTimes");

    setState(() {
      availableTimes =
          presetTimes.where((time) => !bookedTimes.contains(time)).toList();
      print("Available Times: $availableTimes");
      showTimeDropdown = true;
    });
  }

  void bookTable(int tableNo) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(formattedDate)
        .collection("table_$tableNo")
        .doc(selectedTime)
        .set({
      'time': selectedTime,
      'date': formattedDate,
      'user': 'demoUser123', // Replace with actual user ID if available
      'timestamp': Timestamp.now(),
      'status':"pending"
    });

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BookingStatusScreen(userId: 'demoUser123', formattedDate: formattedDate, tableNumber: tableNo, selectedTime: selectedTime,),
      ),
    ).then((_) {
      setState(() {
        visibility = false;
        showTimeDropdown = false;
        selectedTime = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 230, 193),
      body: Consumer<LandingpageViewModel>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 33, top: 33, bottom: 33),
                child: Center(
                  child: Column(
                    children: [
                      for (var i = 0; i < TextsList.length; i++)
                        DelayedDisplay(
                          delay: Duration(milliseconds: 500 * i),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                TextsList[i],
                                style: const TextStyle(
                                    fontSize: 38, fontWeight: FontWeight.w600),
                              ),
                              if (i == 0) const SizedBox(width: 6),
                              if (i == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 12,
                                    width: 12,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFFBD04),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 163, 209, 176),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(180)),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.9,
                            width: MediaQuery.of(context).size.width / 1.3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/image/Noddle.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        provider.isEmpty
                            ? const Text(
                                "No Tables",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              )
                            : Column(
                                children: [
                                  // Table Selection
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Table',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 179, 230, 193),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                              alignment: Alignment.center,
                                              value: provider.dropdownValue,
                                              iconEnabledColor:
                                                  Color(0xFFFFBC04),
                                              items: provider.TableList.map<
                                                  DropdownMenuItem<int>>(
                                                (int value) {
                                                  return DropdownMenuItem<int>(
                                                    value: value,
                                                    child: Text(
                                                      value.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (int? newValue) {
                                                setState(() {
                                                  provider.dropdownValue =
                                                      newValue!;
                                                  visibility = true;
                                                  selectedDate = DateTime.now();
                                                  selectedTime = null;
                                                  showTimeDropdown = false;
                                                });
                                                loadAvailableTimes(
                                                    newValue!, selectedDate);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Booking Options
                                  if (visibility)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Select Date
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Select Date:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 179, 230, 193),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 30)),
                                                  );
                                                  if (pickedDate != null) {
                                                    setState(() {
                                                      selectedDate = pickedDate;
                                                      selectedTime = null;
                                                      showTimeDropdown = false;
                                                    });
                                                    loadAvailableTimes(
                                                        provider.dropdownValue!,
                                                        pickedDate);
                                                  }
                                                },
                                                child: Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(selectedDate),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Select Time
                                        if (showTimeDropdown)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Select Time:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 179, 230, 193),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: availableTimes
                                                                  .isNotEmpty
                                                          ? selectedTime
                                                          : null,
                                                      iconEnabledColor:
                                                          availableTimes
                                                                      .isNotEmpty
                                                              ? const Color(
                                                                  0xFFFFBC04)
                                                              : Colors.red,
                                                      isExpanded: true,
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                        hintText: availableTimes
                                                                    .isNotEmpty
                                                            ? 'Select Time'
                                                            : 'Slot Full',
                                                        hintStyle: const TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      items: availableTimes
                                                                  .isNotEmpty
                                                          ? availableTimes.map(
                                                              (String time) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: time,
                                                                child: Text(
                                                                  time,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList()
                                                          : [],
                                                      onChanged:
                                                          availableTimes
                                                                      .isNotEmpty
                                                              ? (value) {
                                                                  setState(() {
                                                                    selectedTime =
                                                                        value;
                                                                  });
                                                                }
                                                              : null,
                                                    ),

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        // Continue Button
                                        if (selectedTime != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                minimumSize:
                                                    const Size.fromHeight(50),
                                              ),
                                              onPressed: () {
                                                bookTable(
                                                    provider.dropdownValue!);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Image.asset(
                                                    'assets/image/next.png',
                                                    height: 21,
                                                    width: 21,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
