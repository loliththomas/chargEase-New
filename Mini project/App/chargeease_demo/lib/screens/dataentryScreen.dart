import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Detail Entry',
                style: GoogleFonts.getFont(
                  "Poppins",
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0, // Reduced font size for title
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 10.0), // Add spacing

              Image.asset(
                'assets/images/detail.png',
                height: 200,
                width: 250,
              ),

              SizedBox(height: 10.0), // Add spacing

              // Full Name Text Field with container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
              
                
                child: Column(
                  children: [

                    TextField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)
                  ),
                   // Add left and right padding
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 5),

                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone)
                  ),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 14.0),
                ),
                  SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)
                  ),
                   keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 14.0),
                ),

                  SizedBox(height: 5),

                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_month)
                  ),
                   // Add left and right padding
                  style: TextStyle(fontSize: 14.0),
                ),
                  ],
                  
                  // Reduced font size for text fields
                )
                
              ),

              SizedBox(height: 10,), // Add spacing

              // Phone Number Text Field with container
              // Add spacing

              // Elevated button for gender selection
              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your functionality for gender selection (e.g., dropdown menu, radio buttons)
                    print('Selecting gender...'); // Placeholder for now
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gender'),
                      Icon(Icons.arrow_drop_down), // Add dropdown icon
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50.0), // Set button width
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Add spacing

              // Button for continuing
              SizedBox(
                width: 125,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your code to handle form submission (e.g., save data)
                    print('Submitting form...'); // Placeholder for now
                  },
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    //minimumSize: Size(double.infinity, 50.0), // Set button width
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
