//current order test

//LIst Class

class fooddetails {
  int quantity;
  String foodname;
  String rate;
  String image;

  fooddetails(
      {required this.quantity,
      required this.foodname,
      required this.rate,
      required this.image});

  factory fooddetails.fromJson(Map<String, dynamic> json) => fooddetails(
      foodname: json["foodname"],
      quantity: json["quantity"],
      rate: json["rate"],
      image: json['image']);

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
      rate: map['rate'] as String,
      image: map['image'] as String,
    );
  }
}
