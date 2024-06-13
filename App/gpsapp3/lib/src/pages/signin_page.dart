import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpsapp3/src/pages/forgot_password_page.dart';
import 'package:gpsapp3/src/pages/home_page.dart';
import 'package:gpsapp3/src/pages/hometest.dart';
import 'package:gpsapp3/src/eventhandler/check.dart';
import 'package:gpsapp3/src/pages/map_page.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _signinKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool revealPassword = true;

  Future<void> _logIn() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      )
          .then((user) {
        if (!user.user!.emailVerified) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'Please log in your email and click on verification link!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                );
              });
        } else {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => MapPage()));
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('is incorrect')) {
        // Hiển thị thông báo cho người dùng
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Incorrect information. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000D2D),
      body: Scaffold(
        backgroundColor: const Color(0xff000D2D),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      './assets/images/logo1.png',
                      width: MediaQuery.of(context).size.height * 0.3,
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Text(
                      'GPS Tracker',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontFamily: 'Popins',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffDA9F5C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'Welcome to GPS Tracker!!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.none,
                              fontFamily: 'Popins',
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Enter your email and password here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _signinKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: Color(0xff3D3737),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffD6AC7D),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Color(0xff3D3737),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _password,
                                obscureText: revealPassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        revealPassword = !revealPassword;
                                      });
                                    },
                                    icon:
                                    const Icon(Icons.remove_red_eye_sharp),
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffD6AC7D),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Color(0xff390808),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if(_email.text.isEmpty || _password.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Please fill in all fields!'),
                                          ),
                                        );
                                        return;
                                      }
                                      if(!EmailHelper.isValidEmail(_email.text)){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Please enter a valid email address!'),
                                          ),
                                        );
                                        return;
                                      }
                                      if(!PasswordHelper.isPasswordStrong(_password.text)){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Password must be at least 6 characters long!'),
                                          ),
                                        );
                                        return;
                                      }
                                      _logIn();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff000D2D),
                                      foregroundColor: const Color(0xffFFE8E8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 5),
                                      child: Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
