import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserData(String? docId, String parameter) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Owner')
        .doc(docId)
        .get();

    if (documentSnapshot.exists) {
      print("doc id inside getuserdata ${docId}");
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      print("$parameter is   ${userData[parameter]}");
      return userData[parameter];
    } else {
      print('User document does not exist');
      return null;
    }
  } catch (error) {
    print('Error fetching user data: $error');
    return null;
  }
}
