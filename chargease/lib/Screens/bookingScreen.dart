import 'package:chargease/Screens/payementScreen.dart';
import 'package:chargease/Screens/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bookingScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final Map<String, dynamic> stationData;
  final String stationId;
  bookingScreen({required this.prefs, required this.stationData,required this.stationId});

  @override
  State<bookingScreen> createState() => _bookingScreenState();
}

class _bookingScreenState extends State<bookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 87, 177, 188),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 250, 248),
        elevation: 3,
        shadowColor: Colors.grey,
        title: Text(
          'Booking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 250, 248),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 54, 52, 52),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(4, 4))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Booking Details',
                    style: GoogleFonts.getFont("Anek Malayalam",
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Name"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Location: ",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold, fontSize: 16),
                      //     ),
                      //     Text(
                      //       "${widget.stationData["Location"]}",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Available Slots: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Available Slots"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Price: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.stationData["Price"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if(widget.stationData["Available Slots"]!=0){
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => paymentScreen(
                          prefs: widget.prefs,
                          stationData: widget.stationData,
                          stationId: widget.stationId,
                        ),
                      ),
                    );
                    }
                    else if(widget.stationData["Available Slots"]==0){

                      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 174, 227, 234),
              content: Text('No available slots'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(prefs: widget.prefs)));
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF67CEDB),
                      elevation: 3,
                      shadowColor: Colors.black,
                      splashFactory: InkRipple.splashFactory),
                  child: Text(
                    'Book Now',
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
