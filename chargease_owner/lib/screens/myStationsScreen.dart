import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyStationsScreen extends StatefulWidget {
  final String? ownerName;

  MyStationsScreen({required this.ownerName});

  @override
  State<MyStationsScreen> createState() => _MyStationsScreenState();
}

class _MyStationsScreenState extends State<MyStationsScreen> {
void _deleteStation(String documentId, BuildContext context) {
  FirebaseFirestore.instance
      .collection('Stations')
      .doc(documentId)
      .delete()
      .then((value) {
        // Delay showing the AlertDialog for a short duration
        print("Station deleted successfully");
    // Station deleted successfully
    // Optionally, you can show a confirmation message or update the UI
  }).catchError((error) {
    // Error deleting station
    print("Error deleting station: $error");
    // Optionally, you can show an error message to the user
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
          elevation: 3,
          shadowColor: Colors.grey,
        title: Text('My Stations',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Stations')
            .where('OwnerName', isEqualTo: widget.ownerName)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No stations found.'),
            );
          }
          return ListView(
  children: snapshot.data!.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data =
        document.data() as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            data['Name'],
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text('''Slots: ${data['Slots']} 
Location: ${data["Location"]}'''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 174, 227, 234),
              title: Text("Delete Station !",style: TextStyle(fontWeight: FontWeight.bold),),
              content: Text('Are you sure to delete this station'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _deleteStation(document.id,context);
                    Navigator.of(context).pop(); // Pass the document ID to identify the station
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
              // Implement logic to delete the station
              //
            },
          ),
          // Add more details to display as needed
        ),
      ),
    );
  }).toList(),
);

        },
      ),
    );
  }
}
