import 'package:PocketBuddy/widgets/authWidgets/EmailOrPhoneVerified.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/services/AuthServices.dart';

import '../../screens/HomeScreen.dart';
import '../../utils/AuthUtils.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key, required this.switchScreen});

  final Function switchScreen;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _showLoading = false;

  final authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: GoogleFonts.lato(fontSize: 28),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name can't be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "full name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email can't be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _registerPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "password is empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _registerConfirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm password is empty";
                        }
                        if (value.compareTo(_registerPasswordController.text) !=
                            0) {
                          return "Password and confirm password is not match";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "confirm password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_showLoading) return;
                          _switchLoading();
                          registerAccount();
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.all(18)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child:
                            !_showLoading
                                ? Text("Create Account")
                                : SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Already have an Account?"),
                  TextButton(
                    onPressed: () {
                      widget.switchScreen();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _switchLoading() {
    setState(() {
      _showLoading = !_showLoading;
    });
  }

  registerAccount() async {
    // extract data //
    final userEnterName = _fullNameController.text.trim();
    var fullName;
    if(userEnterName.contains(" ")) {
      fullName = _fullNameController.text.trim().split(" ");
    } else {
      fullName = userEnterName;
    }
    final email = _emailController.text.trim();
    final mobileNumber = _mobileNumberController.text.trim();
    final password = _registerPasswordController.text;
    var firstName = "";
    var lastName = "";
    if(userEnterName.contains(" ")) {
      firstName = fullName[0];
      lastName = fullName[1];
    } else {
      firstName = fullName;
    }

    // Bind Data into Object //
    final userDetails = UserDetails(
      userId: '',
      userFirstName: firstName,
      userLastName: lastName,
      email: email,
      mobileNumber: mobileNumber,
      password: password,
      emailVerified: false
    );

    // convert Data into Json
    await authService.createUserAccount(UserDetails.convertToJson(userDetails));

    if (await AuthUtils().havingAuthToken()) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      _showSnapBar("Unable to create an Account!");
    }

    _switchLoading();
    _formKey.currentState?.reset();
  }

  _showSnapBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
