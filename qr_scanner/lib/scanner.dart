import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/users.api.dart';
import 'package:qr_scanner/users.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text('Scan a code'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      var code = scanData.code;

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DisplayPage(data: code);
      }));

      // getData(code);

      // if (await canLaunch(scanData.code)) {
      //   await launch(scanData.code);
      //   controller.resumeCamera();
      // } else {
      //           showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //           return AlertDialog(
      //           title: const Text('Could not find viable url'),
      //         content: SingleChildScrollView(
      //           child: ListBody(
      //             children: <Widget>[
      //               // Text('Barcode Type: ${describeEnum(scanData.format)}'),
      //               Text('Data: ${scanData.code}'),
      //             ],
      //           ),
      //         ),
      //         actions: <Widget>[
      //           TextButton(
      //             child: const Text('Ok'),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //        );
      //     },
      //   ).then((value) => controller.resumeCamera());
      // }
    });
  }
}

Future<Results> getData(String name) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '192.168.137.1',
      port: 3306,
      user: 'root',
      db: 'testdb',
      password: 'WildLife@2020'));

  return await conn.query("select name from users where name = ?", [name]);
}

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  bool isLoading = true;

  int? id;

  @override
  Widget build(BuildContext context) {
    // fetch(widget.data);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // appBar: AppBar(
          //   title: const Text('Api Call'),
          // ),
          child: FutureBuilder(
            future: fetchUsers(widget.data),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: const CircularProgressIndicator(),);
              }
              if (snapshot.hasData) {
               var data = snapshot.data as List<Users>;

                return ListView.builder(
                    itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                      Users user = data[index];
                      return Card(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${user.name}', style: const TextStyle(fontSize: 20),),
                          Text('${user.email}', style: const TextStyle(fontSize: 15),),
                        ]
                        )
                      );
                  },
                );
              }
              return const Text('No Data found');
            },
          )
        ),
      )
      // Center(child: isLoading
      //     ? const CircularProgressIndicator()
      //     : Text(message != null ? message! : widget.data),) ,

    );


  }

  // void fetch(String data) async {
  //   var res = await getData(data);
  //   setState(() {
  //     isLoading = false;
  //     message = res.first[0];
  //   });
  // }
}
