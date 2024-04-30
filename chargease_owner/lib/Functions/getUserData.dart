import 'package:cloud_firestore/cloud_firestore.dart';

String? getUserData(String? docId, String parameter) {
  FirebaseFirestore.instance
      .collection('Owner')
      .doc(docId)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print("doc id is ${docId}");
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      return userData[parameter];
    } else {
      print('User document does not exist');
      return null;
    }
  }).catchError((error) {
    print('Error fetching user data: $error');
    return null;
  });
}
