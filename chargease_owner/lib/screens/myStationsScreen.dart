import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyStationsScreen extends StatelessWidget {
  final String? ownerName;

  MyStationsScreen({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Stations')
            .where('Owner', isEqualTo: ownerName)
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
                child: Stack(
                  children: [
                    Container(
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
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text('Slots: ${data['Slots']}'),
                        // Add more details to display as needed
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          data['Location'],
                          style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
