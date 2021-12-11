// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.id,
    this.customer,
    this.company,
  });

  String id;
  String customer;
  String company;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    customer: json["customer"],
    company: json["company"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer": customer,
    "company": company,
  };
}
