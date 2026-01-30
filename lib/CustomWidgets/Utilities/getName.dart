import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  static final _auth = FirebaseAuth.instance;
  static final _database = FirebaseDatabase.instance.ref('user');

  static Future<void> loadUserName() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No logged-in user found');
      return;
    }

    try {
      final snapshot = await _database.child(user.uid).get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map;
        SessionController.name = data['username']?.toString() ?? "No Name";
        print('User name loaded:====> ${SessionController.name}');
      } else if (user.displayName != null) {
        SessionController.name = user.displayName!;
        print('User name loaded from displayName: ${SessionController.name}');
      } else if (user.email != null) {
        SessionController.name = user.email!.split('@')[0];
        print('User name loaded from email: ${SessionController.name}');
      } else {
        SessionController.name = "Unknown User";
        print('No username found in database for UID: ${user.uid}');
      }
    } catch (e) {
      print('Error loading username: $e');
      SessionController.name = "Unknown User";
    }
  }
}