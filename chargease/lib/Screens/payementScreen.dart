import 'package:chargease/Screens/bookingConfirmationScreen.dart';
import 'package:chargease/widgets/paymentAnimationWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class paymentScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final Map<String, dynamic> stationData;
  final String stationId;

  paymentScreen({required this.prefs, required this.stationData, required this.stationId});

  @override
  State<paymentScreen> createState() => _paymentScreenState();
}

class _paymentScreenState extends State<paymentScreen> {

  
  void _addBooking(BuildContext context, Map<String, dynamic> stationData,String sId)async  {
    
    String? userId=widget.prefs.getString('docId');
    // Bookings.addBooking(stationData["Name"],userId,stationData["Price"], "UPI","Done",stationData["Contact"],Timestamp.now(),stationData['Location']);
    String? documentId = await Bookings.addBooking(stationData["Name"], userId, stationData["Price"], "UPI", "Successfull", stationData["Contact"], Timestamp.now(), stationData['Location']);
    if (documentId != null) {
      _updateAvailableSlots(sId);
    _showPaymentSuccessAnimation(context, widget.prefs, widget.stationData, documentId);
  } else {
    // Handle error adding booking
  }
  }
  
  
void _updateAvailableSlots(String stationId) async {
  try {
    // Get reference to the station document
    DocumentReference stationRef = FirebaseFirestore.instance.collection('Stations').doc(stationId);

    // Retrieve current availableSlots value
    DocumentSnapshot stationSnapshot = await stationRef.get();
    int currentAvailableSlots = stationSnapshot.get('Available Slots');

    // Decrement availableSlots by one
    int newAvailableSlots = currentAvailableSlots - 1;

    // Update the document with the new value
    await stationRef.update({'Available Slots': newAvailableSlots});

    print('Available slots decremented successfully for station with ID: $stationId');
  } catch (e) {
    print('Error decrementing available slots: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF57B1BC),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        elevation: 3,
        shadowColor: Colors.grey,
        title: Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: Color(0xFFF7FAF8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 54, 52, 52),
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(4, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Payment Details',
                  style: GoogleFonts.getFont(
                    "Anek Malayalam",
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Amount: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            "${widget.stationData["Price"]}", // Change this with the actual payment amount
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Method: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            "UPI", // Change this with the selected payment method
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addBooking( context,widget.stationData,widget.stationId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF67CEDB),
                    elevation: 3,
                    shadowColor: Colors.black,
                    splashFactory: InkRipple.splashFactory,
                  ),
                  child: Text(
                    'Pay Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showPaymentSuccessAnimation(BuildContext context,SharedPreferences prefs, Map<String, dynamic> stationData,String bookingId) async {
  

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: PaymentDoneAnimation(), // Show the animation in the dialog
      );
    },
  );

  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => bookingConfirmationScreen(prefs: prefs,stationData: stationData,bookingId: bookingId)));
}



class Bookings {
  static final CollectionReference _bookings =
      FirebaseFirestore.instance.collection('Bookings');

  static Future<String?> addBooking(
      String stationName,
      String? userId,
      double price,
      String paymentMode ,
      String paymentStatus,
      String contact,
      Timestamp time,
      String location
      ) async {
    try {
      DocumentReference docRef= await _bookings.add({
        'stationName': stationName,
        'userId': userId,
        'price': price,
        'stationContact': contact,
        'location': location,
        'paymentMode': paymentMode,
        'paymentStatus': paymentStatus,
        'bookingTime': time,
      });
      print("booking added successfully");
      return docRef.id;
    } catch (e) {
      print("Error adding document: $e");
      return null;
    }
  }
}