import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String _currentStatus = 'Loading...';
  String _predictedHeartRate = 'Loading...';
  String _errorMessage = '';

  // Function to fetch current heart status from Flask backend
  Future<void> _fetchCurrentStatus() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.174.24:5000/predict_status'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('current_status')) {
          setState(() {
            _currentStatus = data['current_status'] ?? 'Unknown';
          });
        } else if (data.containsKey('error')) {
          setState(() {
            _errorMessage = data['error'];
          });
        }
      } else {
        setState(() {
          _currentStatus = 'Failed to load status';
        });
      }
    } catch (e) {
      setState(() {
        _currentStatus = 'Error: $e';
      });
    }
  }

  // Function to fetch predicted future heart rate from Flask backend
  Future<void> _fetchPredictedHeartRate() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.174.24:5000/predict_future'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('predicted_future_heart_rate')) {
          setState(() {
            _predictedHeartRate = data['predicted_future_heart_rate'].toString();
          });
        } else if (data.containsKey('error')) {
          setState(() {
            _errorMessage = data['error'];
          });
        }
      } else {
        setState(() {
          _predictedHeartRate = 'Failed to load heart rate';
        });
      }
    } catch (e) {
      setState(() {
        _predictedHeartRate = 'Error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentStatus(); // Fetch current heart status when the page loads
    _fetchPredictedHeartRate(); // Fetch future heart rate when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Heart Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage.isNotEmpty)
              Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)),
            Text('Current Heart Status: $_currentStatus', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Predicted Future Heart Rate: $_predictedHeartRate bpm', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchCurrentStatus();  // Manually refresh data
                _fetchPredictedHeartRate();
              },
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}
