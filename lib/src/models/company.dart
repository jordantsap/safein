import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  Company({
    this.id,
    this.email,
    this.phone,
    this.name,
  });

  String id;
  String email;
  String phone;
  String name;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "name": name,
      };
}
