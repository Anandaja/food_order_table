import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBookingApprovalPage extends StatefulWidget {
  const AdminBookingApprovalPage({super.key});

  @override
  State<AdminBookingApprovalPage> createState() =>
      _AdminBookingApprovalPageState();
}

class _AdminBookingApprovalPageState extends State<AdminBookingApprovalPage> {
  List<Map<String, dynamic>> allBookings = [];

  final List<String> bookingDates = [
    '2025-06-12',
    '2025-06-13',
    '2025-06-14',
    '2025-06-15',
    '2025-06-16',
    '2025-06-17',
    '2025-06-18',
    '2025-06-19',
    '2025-06-20',
    '2025-06-21',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllBookings();
  }

  Future<void> fetchAllBookings() async {
    List<Map<String, dynamic>> bookings = [];

    for (String date in bookingDates) {
      for (int tableNo = 1; tableNo <= 10; tableNo++) {
        final snapshot = await FirebaseFirestore.instance
            .collection("bookings")
            .doc(date)
            .collection("table_$tableNo")
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          bookings.add({
            'id': doc.id,
            'date': date,
            'tableNo': tableNo,
            'time': data['time'],
            'user': data['user'],
            'status': data['status'],
            'timestamp': data['timestamp'],
          });
        }
      }
    }

    // Sort by date and time
    bookings.sort((a, b) {
      final dateTimeA = DateTime.parse("${a['date']} ${a['time']}");
      final dateTimeB = DateTime.parse("${b['date']} ${b['time']}");
      return dateTimeA.compareTo(dateTimeB);
    });

    setState(() {
      allBookings = bookings;
    });
  }

  Future<void> updateBookingStatus(
      String date, int tableNo, String time, String newStatus) async {
    final docRef = FirebaseFirestore.instance
        .collection("bookings")
        .doc(date)
        .collection("table_$tableNo")
        .doc(time);

    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) return;

    final bookingData = docSnapshot.data();

    if (newStatus == 'rejected') {
      // Move to rejected_bookings
      await FirebaseFirestore.instance.collection("rejected_bookings").add({
        'date': date,
        'tableNo': tableNo,
        'time': time,
        'user': bookingData?['user'],
        'status': 'rejected',
        'timestamp': bookingData?['timestamp'] ?? FieldValue.serverTimestamp(),
      });

      // Delete original
      await docRef.delete();
    } else {
      // Approve the booking
      await docRef.update({'status': newStatus});
    }

    fetchAllBookings(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      appBar: AppBar(
        title: const Text("Admin Booking Approval"),
        backgroundColor: const Color(0xFF81C784),
      ),
      body: allBookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allBookings.length,
              itemBuilder: (context, index) {
                final booking = allBookings[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "Table ${booking['tableNo']} at ${booking['time']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "User: ${booking['user']}\nDate: ${booking['date']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (booking['status'] == 'pending') ...[
                          IconButton(
                            icon: const Icon(Icons.check_circle,
                                color: Colors.green),
                            onPressed: () => updateBookingStatus(
                                booking['date'],
                                booking['tableNo'],
                                booking['time'],
                                'approved'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => updateBookingStatus(
                                booking['date'],
                                booking['tableNo'],
                                booking['time'],
                                'rejected'),
                          ),
                        ] else
                          Text(
                            booking['status'].toUpperCase(),
                            style: TextStyle(
                              color: booking['status'] == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
