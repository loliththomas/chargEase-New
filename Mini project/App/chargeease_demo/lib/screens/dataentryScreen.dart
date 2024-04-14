import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class DataEntryScreen extends StatefulWidget {
  final String phoneNumber;

  DataEntryScreen({required this.phoneNumber});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen>
    with TickerProviderStateMixin {
  String selectedGender = "male";
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
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

  // Reusable button for gender selection (separate function)
  Widget _buildGenderButton(String gender) {
    Color buttonColor = selectedGender == gender
        ? Color.fromARGB(255, 27, 173, 193)
        : Colors.grey; // Set button color based on selection
    return SizedBox(
      width: 95,
      height: 30,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedGender = gender; // Update selected gender on button press
          });
        },
        child: Text(
          gender,
          style: TextStyle(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(
            color: Color.fromARGB(255, 115, 111, 111),
          ), // Set text color based on selection
        ),
      ),
    );
  }

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
                          decoration: InputDecoration(
                            labelText: '*Email ID',
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
                    _buildGenderButton('Male'),
                    _buildGenderButton('Female'),
                    _buildGenderButton('Other'),
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
                            // If all fields are valid, perform the desired action
                            // For example, navigate to the next screen
                            print("not all entries");
                          } else {
                            setState(() {
                              _errorMessage = "Fill all required fields";
                              _controller!.forward(from: 0);
                              Future.delayed(Duration(seconds: 3), () {
                                _controller.reverse();
                              });
                            });
                            _controller.forward(from: 0);
                          }
                        },
                        child: Text('Continue',
                        style: TextStyle(
                          color: Colors.white
                        ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                    const Color.fromARGB(0, 255, 255, 255),
                                // Transparent background to ensure gradient shows
                            ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:[
                          Color.fromARGB(255, 63, 159, 172),
                          Color.fromARGB(255, 38, 123, 233)
                        ] )
                    ),
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
