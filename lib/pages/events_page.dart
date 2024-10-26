import 'package:flutter/material.dart';

class Appointment {
  final String date;
  final String time; // New time property
  final String doctor;
  final String details;

  Appointment({
    required this.date,
    required this.time,
    required this.doctor,
    required this.details,
  });
}

class EventsPage extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      date: '10-10-2024',
      time: '10:00 AM', // Added appointment time
      doctor: 'Dr. Rajesh Kumar',
      details: 'Check-up for blood pressure and cholesterol levels.',
    ),
    Appointment(
      date: '12-10-2024',
      time: '2:30 PM', // Added appointment time
      doctor: 'Dr. Priya Menon',
      details: 'Follow-up appointment for previous treatment.',
    ),
    Appointment(
      date: '15-10-2024',
      time: '11:15 AM', // Added appointment time
      doctor: 'Dr. Amit Desai',
      details: 'Heart rate monitoring and ECG.',
    ),
    Appointment(
      date: '18-10-2024',
      time: '1:00 PM', // Added appointment time
      doctor: 'Dr. Meena Iyer',
      details: 'Consultation regarding recent tests.',
    ),
    Appointment(
      date: '20-10-2024',
      time: '3:30 PM', // Added appointment time
      doctor: 'Dr. Sanjay Gupta',
      details: 'Cardiac rehabilitation session.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments'),
        backgroundColor: Colors.purple[300], // Light purple
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return _buildAppointmentCard(context, appointments[index]);
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    return Card(
      color: Colors.purple[50], // Light purple
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          'Booking Date: ${appointment.date}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700], // Darker purple
          ),
        ),
        subtitle: Text(
          'Doctor: ${appointment.doctor}',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.grey[800],
          ),
        ),
        leading: Icon(
          Icons.calendar_today,
          color: Colors.purple[700], // Darker purple
          size: 30,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.purple[700], // Darker purple
          size: 20,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AppointmentDetailPage(appointment: appointment),
            ),
          );
        },
      ),
    );
  }
}

class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        backgroundColor: Colors.purple[300], // Light purple
      ),
      body: Container(
        color: Colors.purple[50], // Light purple background for the full page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have an appointment on ${appointment.date} at ${appointment.time}.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Doctor: ${appointment.doctor}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Text(
              'Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              appointment.details,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appointment booked successfully!')),
                );
                Navigator.of(context).pop(); // Go back to the events page
              },
              child: Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300], // Light purple button
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventsPage(),
  ));
}
