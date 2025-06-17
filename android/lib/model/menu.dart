//import 'package:firebase_database/firebase_database.dart';

// ignore_for_file: non_constant_identifier_names

class MenuDetails {
  String foodname = '';
  String rate = '';
  String catogary = '';
  late bool isAvailable;
  String image = '';
  // bool New = false; // Default value for bool

  MenuDetails(
      {required this.foodname,
      required this.catogary,
      required this.isAvailable,
      required this.rate,
      required this.image});

  // Serialization method (to Map for RTDB)
  Map<String, dynamic> toMap() {
    return {
      'foodname': foodname,
      'rate': rate,
      'catogary': catogary,
      'isAvailable': isAvailable,
      'image': image
    };
  }

  // Factory method for deserialization (from Map for RTDB)
  factory MenuDetails.fromMap(
      //  Map<String, dynamic>
      dynamic map) {
    return MenuDetails(
        foodname: map['foodname'] as String,
        rate: map['rate'] as String,
        catogary: map['category'] as String,
        isAvailable: map['isAvailable'] as bool,
        image: map['image'] as String);
  }

  // Copy method for creating new instances with modified values
  MenuDetails copyWith({
    required String foodname,
    required String rate,
    required String catogary,
    required bool isAvailable,
  }) =>
      MenuDetails(
          foodname: foodname,
          rate: rate,
          catogary: catogary,
          isAvailable: isAvailable,
          image: image);

  // No need for `fromJson` or `fromDatasnapshot` methods in RTDB
}
