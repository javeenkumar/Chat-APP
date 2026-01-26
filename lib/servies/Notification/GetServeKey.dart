import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Getservekey {

  Future<Map<String, dynamic>> loadServerJson() async {
    final path = dotenv.env['SERVER_KEY_JSON']!;
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString);
    return data;
  }

  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];


    final data = await loadServerJson();

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(data),
      scopes,
    );
    AccessCredentials credentials =await obtainAccessCredentialsViaServiceAccount(
      ServiceAccountCredentials.fromJson(data),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }
}
