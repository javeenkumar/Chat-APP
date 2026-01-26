import 'dart:convert';
import 'package:chatapp/servies/Notification/GetServeKey.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotificationFromFlutter({
  required String deviceToken,
  required String title,
  required String body,
  required Map<String,dynamic>? data
}) async {
  String serverKey = await Getservekey().getServerKeyToken();
   String url = dotenv.env['URL']!;

  var header = <String,String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $serverKey'
  };

  Map<String,dynamic> message ={
    "message": {
      "token": deviceToken,
      "notification": {
        "title": title,
        "body": body,
      },
      'data':data
    }
  };

  try{
    final response = await http.post(Uri.parse(url),
        headers: header,
        body: jsonEncode(message));

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }catch (e){
    print(e.toString());
  }
}
