import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gpsapp3/src/components/box.dart';
import 'package:gpsapp3/src/components/box2.dart';
import 'package:gpsapp3/src/components/drawer.dart';
import 'package:gpsapp3/src/eventhandler/check.dart';
import 'package:gpsapp3/src/pages/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  DatabaseReference _reference = FirebaseDatabase.instance.ref();
  String _name = '';
  String _seri = '';
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();  
  var confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
        _reference = FirebaseDatabase.instance.ref('USER').child(_currentUser!.uid);
      });
      _listenForData();
    }
  }

  // Future<void> editField(String field) async {
  //   String newValue = '';
  //   await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         backgroundColor: Colors.grey[900],
  //         title: Text(
  //           "Edit $field",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         content: TextField(
  //           autofocus: true,
  //           style: TextStyle(color: Colors.white),
  //           decoration: InputDecoration(
  //             hintText: "Enter new $field",
  //             hintStyle: TextStyle(color: Colors.grey),
  //           ),
  //           onChanged: (value) {
  //             newValue = value;
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text(
  //               'Cancel', style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           TextButton(
  //             child: Text(
  //               'Save', style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () => Navigator.of(context).pop(newValue),
  //           ),
  //         ],
  //       ),
  //   );

  //   if(newValue.trim().length > 0) {
  //     _reference.update({field: newValue});
  //   }
  // }

  Future<void> editField(String field) async {
    String newValue = '';
    final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit $field",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel', style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Save', style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ],
        ),
    );

    if(result != null && result.trim().length > 0) {
      _reference.update({field: result});
    }
  }

  void _listenForData() {
    _reference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          _name = data['name'] ?? ''; // Set default value if 'Name' is missing
          _seri = data['seri'] ?? ''; // Set default value if 'Seri' is missing
        });
      }
    });
  }

  void clearTextFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }


  Future<void> changeField() async {
    String newValue = '';
    final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Change password",
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                controller: oldPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  // hintText: '********',
                  labelText: 'Old password',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  // hintText: '********',
                  labelText: 'New password',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: confirmNewPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  // hintText: '********',
                  labelText: 'Confirm new password',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel', style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                clearTextFields();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Save', style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // await changePassword(
                //   email: _currentUser!.email!,
                //   oldPassword: oldPasswordController.text,
                //   newPassword: newPasswordController.text,
                // );
                // Navigator.pop(context);
                if(oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields!'),
                    ),
                  );
                  return;
                }
                if(!PasswordHelper.isPasswordStrong(oldPasswordController.text) || !PasswordHelper.isPasswordStrong(newPasswordController.text)){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text('Password must be at least 6 characters long!'),
                    ),
                  );
                  return;
                }
                if(!PasswordHelper.isPasswordMatch(newPasswordController.text, confirmNewPasswordController.text)){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text('Please check your password!'),
                    ),
                  );
                  return;
                }
                try {
                  var cred = EmailAuthProvider.credential(
                      email: _currentUser!.email!,
                      password: oldPasswordController.text);
                  await _currentUser!
                      .reauthenticateWithCredential(cred);
                  // Nếu mật khẩu cũ chính xác, thực hiện thay đổi mật khẩu mới
                  await changePassword(
                    email: _currentUser!.email!,
                    oldPassword: oldPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                  // Hiển thị thông báo thành công sử dụng sca
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully!'),
                    ),
                  );

                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text("Success"),
                  //       content: Text("Password changed successfully."),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text("OK"),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                  Navigator.pop(context);
                  clearTextFields();
                } catch (error) {
                  // Hiển thị thông báo lỗi nếu mật khẩu cũ không chính xác
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Old password is incorrect."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
    );
  }


  changePassword({email, oldPassword, newPassword}) async {
    var cred = EmailAuthProvider.credential(email: email, password: oldPassword);

    await _currentUser!.reauthenticateWithCredential(cred).then((value) {
      _currentUser!.updatePassword(newPassword);
    }).catchError((onError) {
      print("==========================================================================");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff000D2D),
          iconTheme: IconThemeData(
            color: Colors.white, // Màu trắng cho biểu tượng menu
          ),
        ),
        drawer: profileUser(),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.blue,
            ),
            if (_currentUser != null)
              Center(child: Text('Email: ${_currentUser!.email}')),

            Box(
              text: 'Name',
              sectionName: _name,
              onPressed: () => editField('name'),
            ),
            Box(
              text: 'Seri number',
              sectionName: _seri,
              onPressed: () => editField('seri'),
            ),
            Box2(
              text: 'Change password',
              onPressed: () => changeField(),
            ),
          ],
        ));
  }
}
