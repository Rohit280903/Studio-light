import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';  // Import for Bluetooth scanning

import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Studio Lights"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _scanForDevices();
              },
              child: Container(
                height: 45,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _isScanning ? "Scanning..." : "Scan Devices",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isScanning
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _scanResults.length,
                      itemBuilder: (context, index) {
                        final result = _scanResults[index];
                        return ListTile(
                          title: Text(result.device.name.isEmpty
                              ? "Unknown Device"
                              : result.device.name),
                          subtitle: Text(result.device.id.toString()),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
                showToast(message: "Successfully signed out");
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scanForDevices() {
    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    _flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      setState(() {
        _scanResults.add(scanResult);
      });
    }, onDone: () {
      setState(() {
        _isScanning = false;
      });
    });
  }
}
