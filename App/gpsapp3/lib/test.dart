import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // add function
  Future<void> _addData(String task) async {
    Timestamp _date = Timestamp.fromDate(DateTime.now());
    CollectionReference tasks = FirebaseFirestore.instance.collection('baoloc');

    return tasks
        .add({
          'bin1': task,
          'number': 5,
        })
        .then((value) => print('New task added'))
        .catchError((error) => print('Failed to add task: $error'));
  }

  Future<void> _updateData(String id) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('baoloc');
    return tasks
        .doc(id)
        .update(
          {'number': 30},
        )
        .then((value) => print('data has been set!'))
        .catchError((error) => print('Failed to set data!'));
  }

  Future<void> _deleteData(String id) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('baoloc');
    return tasks
        .doc(id)
        .delete()
        .then((value) => print('data has been delete!'))
        .catchError((error) => print('Failed to delete data!'));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter to do app',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.purple,
              displayColor: Colors.black,
              fontFamily: 'Popins',
            ),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter to do app'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('baoloc').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Somethong Wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        _updateData(document.id);
                      },
                      child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(data['bin1']),
                            subtitle: Text(data['number'].toString()),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteData(document.id);
                                }),
                          )),
                    );
                  }).toList(),
                );
              }
              return const Center(
                child: Text('Loading....'),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addData('Create a new task');
            },
            child: const Icon(Icons.add),
          )),
    );
  }
}
