import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../servies/session_controller.dart';

class FirebaseDatabaseService {
  static Future<void> updateUserField(
      BuildContext context,
      String fieldName,
      dynamic newValue
      ) async {
    try {
      await FirebaseDatabase.instance
          .ref('user')
          .child(SessionController.userId.toString())
          .update({
        fieldName: newValue,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$fieldName updated successfully"),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update $fieldName: $e"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
