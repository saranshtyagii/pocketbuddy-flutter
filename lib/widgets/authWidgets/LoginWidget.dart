import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/services/AuthServices.dart';
import 'package:PocketBuddy/services/UserServices.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:PocketBuddy/utils/DeviceInfoUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/HomeScreen.dart';

class Loginwidget extends StatefulWidget {
  const Loginwidget({super.key, required this.switchScreen});

  final Function switchScreen;

  @override
  State<Loginwidget> createState() => _LoginwidgetState();
}

class _LoginwidgetState extends State<Loginwidget> {
  num configCount = 0; // ToDo: remove when make it live

  final _loginFormKey = GlobalKey<FormState>();

  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _otpController = TextEditingController();

  bool _passwordVisibility = false;
  bool _showLoading = false;
  bool _showResetPasswordLoading = false;
  bool _isOtpGenerateRequested = false;
  bool _resendOtp = false;

  final authService = AuthServices();
  final userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: GoogleFonts.lato(fontSize: 18)),
                    SizedBox(height: 4),
                    Text(
                      'Login to your Account!',
                      style: GoogleFonts.lato(fontSize: 24),
                    ),
                    SizedBox(height: 36),
                    TextFormField(
                      controller: _emailOrUsernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "email can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisibility,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisibility = !_passwordVisibility;
                            });
                          },
                          icon:
                              _passwordVisibility
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "password can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _buildForgotPassword();
                          },
                          child: Text(
                            'forgot password?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_showLoading) return;
                          _switchLoading(true, false);
                          authenticateUser();
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
                                ? Text("Login")
                                : SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You don't have an account?"),
                  TextButton(
                    onPressed: () {
                      widget.switchScreen();
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(child: Text('OR')),
              SizedBox(height: 24),
              InkWell(
                onTap: () {
                  configCount += 1;
                  print(configCount);
                  if (configCount == 8) {
                    _showConfigDialog(context);
                    configCount = 0;
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google_logo.png",
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Login With Google",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 22),
              InkWell(
                onTap: () {
                  _buildLoginWithPhone();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Theme.of(context).colorScheme.surface,),
                      SizedBox(width: 8),
                      Text(
                        "Login With Phone",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _switchLoading(bool loginLoading, bool resetLogin) {
    setState(() {
      if (loginLoading) {
        _showLoading = !_showLoading;
      } else {
        _showResetPasswordLoading = !_showResetPasswordLoading;
      }
    });
  }

  _buildForgotPassword() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Reset your Password",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 36),
                    TextFormField(
                      controller: _emailOrUsernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_showResetPasswordLoading) {
                            _loginFormKey.currentState!.validate();
                            _forgotPassword();
                          }
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
                            !_showResetPasswordLoading
                                ? Text("Reset Password")
                                : SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildLoginWithPhone() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Login With Phone",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 36),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter your Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    if(_isOtpGenerateRequested)
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter your OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    if(_isOtpGenerateRequested) SizedBox(height: 18),
                    if(_isOtpGenerateRequested)
                      Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Resend otp in: 59")
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_showResetPasswordLoading) {
                            _loginFormKey.currentState!.validate();
                            _forgotPassword();
                          }
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
                        !_showResetPasswordLoading
                            ? Text(!_resendOtp ? "Generate OTP" : "Resend OTP")
                            : SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color:
                            Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  authenticateUser() async {
    // extract data
    final email = _emailOrUsernameController.text.trim();
    final password = _passwordController.text;

    // fetch device details
    final DeviceInfoUtils deviceInfo = await DeviceInfoUtils.init();

    // Bind Data as JSON
    Map<String, dynamic> userCredentials = {
      'email': email,
      'password': password,
      'deviceId': deviceInfo.deviceId,
      'ipAddress': deviceInfo.ipAddress,
      'modelName': deviceInfo.modelName,
      'modelVersion': deviceInfo.modelVersion,
      'osVersion': deviceInfo.osVersion,
      'appVersion': deviceInfo.appVersion,
    };

    await authService.authenticateUserAccount(userCredentials);

    if (await AuthUtils().havingAuthToken()) {
      await userServices.fetchUserDetails(email);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      _loginFormKey.currentState!.reset();
    } else {
      _showSnapBar('Invalid username or password');
    }

    _switchLoading(true, false);
  }

  _forgotPassword() async {
    _switchLoading(false, true);
    // extract the data
    final String usernameOrEmail = _emailOrUsernameController.text.trim();

    String response = await authService.forgotPassword(usernameOrEmail);

    if (response.isNotEmpty) {
      Navigator.of(context).pop();
      _showSnapBar(response);
    } else {
      _showSnapBar("Unable to forgot password.");
    }

    _switchLoading(false, true);
    _loginFormKey.currentState?.reset();
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
  
  void _showConfigDialog(BuildContext context) {
    final TextEditingController _hostController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Host Port Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: 'Host Port Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.network_check),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final hostPortName = _hostController.text;

                if (hostPortName.isNotEmpty) {
                  // Save to secure storage
                  await storage.write(key: 'hostPortName', value: hostPortName);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Host port name saved!')),
                  );

                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid port name.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
