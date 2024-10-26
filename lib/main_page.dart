import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _status = '';
  double _predictedHeartRate = 0.0;

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/predict_status'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _status = data['current_status'];
        _predictedHeartRate = data['predicted_future_heart_rate'];
      });
    } else {
      throw Exception('Failed to fetch heart rate data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate Monitoring'),
      ),
      body: Column(
        children: <Widget>[
          Text('Current Status: $_status'),
          Text('Predicted Future Heart Rate: $_predictedHeartRate'),
          ElevatedButton(
            onPressed: _fetchData,
            child: Text('Fetch Heart Rate Data'),
          ),
        ],
      ),
    );
  }
}
