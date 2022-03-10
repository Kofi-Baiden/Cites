import 'package:flutter/material.dart';
import 'package:qr_scanner/scanner.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FORESTRY COMMISSION',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'FORESTRY COMMISSION'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text.rich(
              TextSpan(
                text: 'Welcome   ',
                style: TextStyle(fontWeight: FontWeight.bold,),
                children: [
                  TextSpan(
                    text: 'Forester',
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.green)
                  ),
                ]
              ),
              style: TextStyle(fontSize: 47),
            ),
            const SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                hintText: 'CITES: FORESTRY COMMISSION',
              ),
            ),
            Center(
              child: Image.asset('assets/forestry.png'),
            ),
            Center(
              child: ElevatedButton(
                  child: const Text('Scan'),
                  onPressed: () {
                    // get().then((value) => debugPrint(value)).catchError((err)=>debugPrint(err.toString()));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Scanner()),
                    );
                  }),
            ),
          ],
          ),
          ),
        ],
      )
    );
  }
}

Future get () async {
  // Open a connection
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'testdb',
      password: 'WildLife@2020'));

  debugPrint(conn.toString());

  // Insert some data
  var result = await conn.query(
      'insert into users (name, email, age) values (?, ?, ?)',
      ['Bob', 'bob@bob.com', 25]);
  debugPrint('Inserted row id=${result.insertId}');

  // Query the database using a parameterized query
  var results = await conn.query(
      'select * from users');
      // 'select name, email, age from users where id = ?', [result.insertId]);
  for (var row in results) {
    debugPrint('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Update some data
  // await conn.query('update users set age=? where name=?', [26, 'Bob']);
  //
  // // Query again database using a parameterized query
  // var results2 = await conn.query(
  //     'select name, email, age from users where id = ?', [result.insertId]);
  // for (var row in results2) {
  //   debugPrint('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  // }

  // Finally, close the connection
  await conn.close();
}
