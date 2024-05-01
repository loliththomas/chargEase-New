import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingsScreen extends StatefulWidget {
  final SharedPreferences prefs;
  MyBookingsScreen({required this.prefs});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {

  late String stationId;

  // void _getStation(Map<String, dynamic> data)
  // {
  //   setState(() {
  //     stationId = data['stationId'];
  //   });

  // }

  void _updateAvailableSlots(String stationId) async {
  try {
    // Get reference to the station document
    DocumentReference stationRef = FirebaseFirestore.instance.collection('Stations').doc(stationId);

    // Retrieve current availableSlots value
    DocumentSnapshot stationSnapshot = await stationRef.get();
    int currentAvailableSlots = stationSnapshot.get('Available Slots');

    // Decrement availableSlots by one
    int newAvailableSlots = currentAvailableSlots + 1;

    // Update the document with the new value
    await stationRef.update({'Available Slots': newAvailableSlots});

    print('Available slots incremented successfully for station with ID: $stationId');
  } catch (e) {
    print('Error decrementing available slots: $e');
  }
}
  void _cancelBooking(String documentId, BuildContext context,String stationId) {
    
    FirebaseFirestore.instance
        .collection('Bookings')
        .doc(documentId)
        .delete()
        .then((value) {
      // Delay showing the AlertDialog for a short duration
      print("Booking canceled successfully");
      // Booking canceled successfully
      // Optionally, you can show a confirmation message or update the UI
    }).catchError((error) {
      // Error canceling booking
      print("Error canceling booking: $error");
      // Optionally, you can show an error message to the user
    });
    _updateAvailableSlots(stationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        elevation: 3,
        shadowColor: Colors.grey,
        title: Text('My Bookings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .where('userId', isEqualTo: widget.prefs.getString("docId"))
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
              child: Text('No bookings found.'),
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
                      data['stationName'],
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: 
                        Text("Location: ${data["location"]}"),
                      
                    
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(255, 174, 227, 234),
                              title: Text(
                                "Cancel Booking !",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                  'Are you sure you want to cancel this booking?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    //_getStation(data);
                                    _cancelBooking(document.id, context,data["stationId"]);
                                    Navigator.of(context).pop();
                                    // Pass the document ID to identify the booking
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF289AA9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust border radius as needed
                        ),
                      ),
                      child: Text("Cancel",style: TextStyle(color: Colors.white),),
                    ),
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
