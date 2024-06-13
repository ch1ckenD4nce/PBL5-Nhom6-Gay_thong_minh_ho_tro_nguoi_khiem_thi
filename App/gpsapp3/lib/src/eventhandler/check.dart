import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EmailHelper {
  static bool isValidEmail(String email) {
    // Triển khai kiểm tra định dạng email ở đây
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email) &&
        (email.endsWith('.com') || email.endsWith('.vn'));
  }
}

class PasswordHelper {
  static bool isPasswordValid(String password) {
    // Triển khai kiểm tra mật khẩu ở đây
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  static bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isPasswordStrong(String password) {
    return password.length >= 6;
  }
}



// class UserHelper {
//   static Future<bool> checkUserlExist(String email) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('database')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }
// }

class UserHelper {
  static Future<bool> checkUserExist(String email) async {
    try {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('Database');
      DataSnapshot snapshot = (await dbRef.orderByChild('email').equalTo(email).once()).snapshot;
      return snapshot.value != null;
    } catch (e) {
      return false;
    }
  }
}
