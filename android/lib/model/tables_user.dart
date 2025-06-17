// ignore_for_file: non_constant_identifier_names

class TableDetailsuser {
  int TableNo;
  late bool Availability;

  // bool New = false; // Default value for bool

  TableDetailsuser(
      {required this.TableNo,
      required this.Availability,
      });

  // Serialization method (to Map for RTDB)
  Map<String, dynamic> toMap() {
    return {
      'TableNo': TableNo,
      'Availability': Availability,   
    };
  }

  // Factory method for deserialization (from Map for RTDB)
  factory TableDetailsuser.fromMap(
      //  Map<String, dynamic>
      dynamic map) {
    return TableDetailsuser(
        Availability: map['Availability'] as bool,
        TableNo: map['TableNo'] as int,
       
        );
  }

  // Copy method for creating new instances with modified values
  TableDetailsuser copyWith(
          {required bool Availability,
          required int TableNo,
         }) =>
      TableDetailsuser(
          TableNo: TableNo, Availability: Availability,);

  // No need for `fromJson` or `fromDatasnapshot` methods in RTDB
}
