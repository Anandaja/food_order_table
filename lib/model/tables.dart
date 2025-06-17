//import 'package:firebase_database/firebase_database.dart';

// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

class TableDetails {
  int TableNo;
  late bool Availability;
  var Ongoingord;
  // bool New = false; // Default value for bool

  TableDetails(
      {required this.TableNo,
      required this.Availability,
      required this.Ongoingord});

  // Serialization method (to Map for RTDB)
  Map<String, dynamic> toMap() {
    return {
      'TableNo': TableNo,
      'Availability': Availability,
      'Ongoing Order': Ongoingord
    };
  }

  // Factory method for deserialization (from Map for RTDB)
  factory TableDetails.fromMap(
      //  Map<String, dynamic>
      dynamic map) {
    return TableDetails(
        Availability: map['Availability'] as bool,
        TableNo: map['TableNo'] as int,
        Ongoingord: map['Ongoing Order'] //as??
        );
  }

  // Copy method for creating new instances with modified values
  TableDetails copyWith(
          {required bool Availability,
          required int TableNo,
          required var OngoingOrder}) =>
      TableDetails(
          TableNo: TableNo, Availability: Availability, Ongoingord: Ongoingord);

  // No need for `fromJson` or `fromDatasnapshot` methods in RTDB
}

//current order test

class OngoingOrder {
  String uniqeid = '';
  int TableNo;
  late bool New; //ordering true bool
  List<fooddetails> foods;

  //can we add total rate here .??

  OngoingOrder(
      {required this.TableNo,
      required this.New,
      required this.uniqeid,
      required this.foods});

  // Factory method for deserialization (from Map for RTDB)
  factory OngoingOrder.fromMap(Map<String, dynamic> map) {
    return OngoingOrder(
        New: map['New'] as bool,
        TableNo: map['TableNo'] as int,
        uniqeid: map['uniqeid'] as String,
        foods: List<fooddetails>.from(
            map["foods"].map((x) => fooddetails.fromJson(x))));
  }

  factory OngoingOrder.fromJson(Map<String, dynamic> json) => OngoingOrder(
        TableNo: json["TableNo"],
        New: json["New"],
        uniqeid: json["uniqeid"],
        foods: List<fooddetails>.from(
            json["foods"].map((x) => fooddetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TableNo": TableNo,
        "New": New,
        "uniqeid": uniqeid,
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
      };
}

//LIst Class

class fooddetails {
  int quantity;
  String foodname;
  String rate;

  fooddetails({
    required this.quantity,
    required this.foodname,
    required this.rate,
  });

  factory fooddetails.fromJson(Map<String, dynamic> json) => fooddetails(
        foodname: json["foodname"],
        quantity: json["quantity"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "foodname": foodname,
        "quantity": quantity,
        "rate": rate,
      };
  factory fooddetails.fromMap(
      //  Map<String, dynamic>
      dynamic map) {
    return fooddetails(
        foodname: map['foodname'] as String,
        quantity: map['quantity'] as int,
        rate: map['rate'] as String);
  }
}
