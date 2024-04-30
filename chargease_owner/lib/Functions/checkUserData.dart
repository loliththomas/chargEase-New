import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to check if user exists and get the UID
Future<String?> checkUserData(String phoneNumber, Function(bool) onUserExist) async {
  try {
    CollectionReference owners = FirebaseFirestore.instance.collection('Owner');
    QuerySnapshot querySnapshot = await owners.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (querySnapshot.docs.isNotEmpty) {
      print("User Exists ");
      print("${querySnapshot.docs.first.id}");
      onUserExist(true); // Set userExists to true
      return querySnapshot.docs.first.id; // Return the document ID (UID)
    } else {
      print('no user');
      onUserExist(false); // Set userExists to false
      return null; // User not found
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}

// Other authentication-related functions can be defined here
