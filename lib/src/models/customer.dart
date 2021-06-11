import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.id,
    this.firstname,
    this.lastname,
    this.companyId,
    this.phone,
  });

  String id;
  String firstname;
  String lastname;
  int companyId;
  String phone;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        companyId: json["company_id"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "company_id": companyId,
        "phone": phone,
      };
}
