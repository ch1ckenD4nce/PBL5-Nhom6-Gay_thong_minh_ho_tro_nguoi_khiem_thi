import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gpsapp3/main.dart';
import 'package:gpsapp3/src/eventhandler/auth_state.dart';
import 'package:gpsapp3/src/eventhandler/check.dart';
import 'package:gpsapp3/src/pages/home_page.dart';
import 'package:gpsapp3/src/pages/signin_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _seri = TextEditingController();
  final dataBaseReference = FirebaseDatabase.instance.ref("USER");
  final _signupKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool revealPassword = true;

  Future<void> _signUp() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      )
          .then((UserCredential? userCredential) {
        if (userCredential != null) {
          String userId = userCredential.user!.uid;
          String email = userCredential.user!.email!;
          String password = _password.text;
          _createUser(userId, email, _name.text, _seri.text, password); // Pass text values
          _sendEmailVerification();
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains(
          'The email address is already in use by another account.')) {
        // Hiển thị thông báo cho người dùng
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'The email address is already in use by another account. Please use another email address!'),
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

  Future<void> _sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification().whenComplete(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email Verification'),
              content: const Text(
                  'Verification Email sent! Please check your email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => AuthState()));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } catch (e) {
      print("Error sending email verification: $e");
    }
  }

  Future<void> _createUser(String userID, String email, String name, String seri, String password) async {
    try {
      dataBaseReference.child(userID).set({
        'email': email,
        'name': name,
        'seri': seri,
        // 'password': password,
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000D2D),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                      const SizedBox(height: 20),
                      Form(
                        key: _signupKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your name',
                              style: TextStyle(
                                color: Color(0xff3D3737),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _name,
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
                              'Seri number',
                              style: TextStyle(
                                color: Color(0xff3D3737),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _seri,
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
                              'Email',
                              style: TextStyle(
                                color: Color(0xff3D3737),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _email,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 51, 36, 36),
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
                            TextField(
                              controller: _password,
                              obscureText: revealPassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      revealPassword = !revealPassword;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_red_eye_sharp),
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
                            const Text(
                              'Confirm password',
                              style: TextStyle(
                                color: Color(0xff3D3737),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextField(
                              controller: _confirmPassword,
                              obscureText: revealPassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      revealPassword = !revealPassword;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_red_eye_sharp),
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
                              height: 30,
                            ),
                            Center(
                              child: SizedBox(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(_email.text.isEmpty || _password.text.isEmpty || _name.text.isEmpty || _seri.text.isEmpty || _confirmPassword.text.isEmpty) {
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

                                    if(!PasswordHelper.isPasswordMatch(_password.text, _confirmPassword.text)){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Please check your password!'),
                                        ),
                                      );
                                      return;
                                    }

                                    _signUp();
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
                                      'SIGN UP',
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
    );
  }
}
