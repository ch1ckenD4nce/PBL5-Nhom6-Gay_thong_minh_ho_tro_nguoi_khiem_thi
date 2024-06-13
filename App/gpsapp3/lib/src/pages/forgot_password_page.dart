import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gpsapp3/src/eventhandler/auth_state.dart';
import 'package:gpsapp3/src/eventhandler/check.dart';
import 'package:gpsapp3/src/pages/signin_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  final _resetKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: _email.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Password'),
            content: const Text('Please check your email to reset password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SigninPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        // Handle different FirebaseAuthException codes
        switch (e.code) {
          case 'user-not-found':
            message = 'This email is not registered!';
            break;
          case 'invalid-email':
            message = 'Please enter a valid email address!';
            break;
          default:
            message = 'An error occurred. Please try again later.';
        }
      } else {
        message = 'An unexpected error occurred.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 30.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff000D2D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'GPS Tracker',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
                key: _resetKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff3D3737),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.person),
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: const Color(0xffF0EDEA),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Center(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                // kiểm tra trống 
                                if(_email.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please fill in email fields!'),
                                    ),
                                  );
                                  return;
                                }
                                // kiểm tra định dạng email
                                if(!EmailHelper.isValidEmail(_email.text)){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid email address!'),
                                    ),
                                  );
                                  return;
                                }
                                bool userExists = await UserHelper.checkUserExist(_email.text);
                                if(!userExists){
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('This email is not registered!'),
                                    ),
                                  );
                                  return;
                                }

                                // ignore: use_build_context_synchronously
                                _resetPassword(context);



                                // if (_email.text.isNotEmpty) {
                                //   if (EmailHelper.isValidEmail(_email.text)) {
                                //     if (_resetKey.currentState!.validate()) {
                                //       _resetPassword(context);
                                //     }
                                //   } else {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //         content: Text(
                                //             'Please enter a valid email address!'),
                                //       ),
                                //     );
                                //   }
                                // } else {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content:
                                //           Text('Please enter a your email!'),
                                //     ),
                                //   );
                                // }

                                /*showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      content: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'The 6-Digit code was sent to email address:',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'example@example.com',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Check your mail box in order to reset your password. Thank you!!', // Dòng văn bản thứ ba
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );*/
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff000D2D),
                                foregroundColor: const Color(0xffFFE8E8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 4),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'This site is protected by hCaptcha and its ',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle tap on Privacy Policy
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle tap on Terms of Service
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TermsOfServiceScreen(),
                                      ),
                                    );
                                  },
                              ),
                              const TextSpan(text: ' apply.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Center(
        child: Text('Privacy Policy content'),
      ),
    );
  }
}

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
      ),
      body: Center(
        child: Text('Terms of Service content'),
      ),
    );
  }
}
