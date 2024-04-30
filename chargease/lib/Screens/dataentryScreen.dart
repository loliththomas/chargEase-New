//import 'package:chargease/Screens/searchScreen.dart';
import 'package:chargease/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:chargease/widgets/GenderButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DataEntryScreen extends StatefulWidget {
  final String phoneNumber;
  final SharedPreferences prefs;
  DataEntryScreen({required this.phoneNumber,required this.prefs});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen>
    with TickerProviderStateMixin {
  String selectedGender = "male";
  String? userExist='n';
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  Map<String, dynamic>? userData;
  //texteditingcontrollers
  final nameController = TextEditingController();
  //final mobileController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//Funtion to check if the user is already existing



// Function to show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    fontSize: 18.0, // Reduced font size for title
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0), // Add spacing
              Image.asset(
                'assets/images/detail.png',
                height: 150,
                width: 250,
              ),
              SizedBox(height: 0.0), // Add spacing
              // Full Name Text Field with container
              Container(
                height: 320,
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _offsetAnimation,
                        child: Text(
                          _errorMessage ?? "*required fields",
                          style: TextStyle(
                            color: _errorMessage == null
                                ? Color.fromARGB(255, 115, 111, 111)
                                : Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: '*Full Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 10.0,
                            ), // Adjust content padding
                          ),
                          style:
                              TextStyle(fontSize: 16.0), // Adjust the font size
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          initialValue: widget.phoneNumber,
                          //controller: mobileController,
                          decoration: InputDecoration(
                            labelText: '*Phone Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 10.0,
                            ), // Adjust content padding
                          ),
                          keyboardType: TextInputType.phone,
                          style:
                              TextStyle(fontSize: 16.0), // Adjust the font size
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: '*E-mail ID',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 10.0,
                            ), // Adjust content padding
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style:
                              TextStyle(fontSize: 16.0), // Adjust the font size
                          validator: (value) {
                            if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value!)) {
                              return 'enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: '*Date of Birth',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_month),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 10.0,
                                  ), // Adjust content padding
                                ),
                                style: TextStyle(
                                    fontSize: 16.0), // Adjust the font size
                                readOnly: true,
                                onTap: () {
                                  _selectDate(context);
                                },
                                controller: TextEditingController(
                                  text: _selectedDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate!)
                                      : null,
                                ),
                              ),
                            ),
                            /*IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0,
              ), // Add spacing
              // Gender selection row using the _buildGenderButton function
              Container(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // Distribute buttons evenly
                  children: [
                    Icon(Icons.wc),
                    GenderButton(
                      gender: 'Male',
                      selectedGender:
                          selectedGender, // Pass the selected gender here
                      onPressed: (gender) {
                        setState(() {
                          selectedGender =
                              gender; // Assign the selected gender to selectedGender
                        });
                      },
                    ),
                    GenderButton(
                      gender: 'Female',
                      selectedGender:
                          selectedGender, // Pass the selected gender here
                      onPressed: (gender) {
                        setState(() {
                          selectedGender =
                              gender; // Assign the selected gender to selectedGender
                        });
                      },
                    ),
                    GenderButton(
                      gender: 'Other',
                      selectedGender:
                          selectedGender, // Pass the selected gender here
                      onPressed: (gender) {
                        setState(() {
                          selectedGender =
                              gender; // Assign the selected gender to selectedGender
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Button for continuing
              SizedBox(
                width: 125,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: DecoratedBox(
                    child: SizedBox(
                      height: 110,
                      width: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Validate form fields
                            // Check if user data exists
                            
                              // Write data to Firestore
                              try {
                                CollectionReference collRef = FirebaseFirestore
                                    .instance
                                    .collection("Users");
                                collRef.add({
                                  'Name': nameController.text,
                                  'Email': emailController.text,
                                  'DOB': _selectedDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate!)
                                      : null,
                                  'Gender': selectedGender,
                                  'phoneNumber': widget.phoneNumber
                                }).then((DocumentReference document) {
                                  // Use DocumentReference
                                  // Get the document ID (UID) of the newly created document
                                  String docId = document.id;

                                  print(
                                      'Data stored successfully with document ID: $docId');
                                  widget.prefs.setString('docId', docId);
                                  // Navigate to addStationScreen and pass the document ID
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          homeScreen(prefs: widget.prefs,),
                                    ),
                                  );
                                }).catchError((error) {
                                  print('Error storing data: $error');
                                });
                              } catch (error) {
                                print('Error storing data: $error');
                              }
                            }
                           else {
                            // If form fields are not valid, show error message
                            setState(() {
                              _errorMessage = "Fill all required fields";
                              _controller.forward(from: 0);
                              Future.delayed(Duration(seconds: 3), () {
                                _controller.reverse();
                              });
                            });
                            _controller.forward(from: 0);
                          }
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(0, 255, 255, 255),
                          // Transparent background to ensure gradient shows
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 63, 159, 172),
                      Color.fromARGB(255, 38, 123, 233)
                    ])),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
