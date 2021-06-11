// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;

Issue issueFromJson(String str) => Issue.fromJson(json.decode(str));

String issueToJson(Issue data) => json.encode(data.toJson());

class Issue {
  Issue({
    this.id,
    this.type,
  });

  String id;
  List<String> type;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        id: json["id"],
        type: List<String>.from(json["type"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": List<dynamic>.from(type.map((x) => x)),
      };
}

// Future<Issue> addIssue() async {
//   final response = await http.post(Uri.http('appserver.anathesis.eu/api/history', 'create'));
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userPhone;
//   prefs.getString("userPhone");
//   prefs.getString("bookerCode");
//   // prefs.setString("bookerPosition", mapLink);
//   return null;
//
// }
