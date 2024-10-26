import 'package:flutter/material.dart';

class DoctorPage extends StatelessWidget {
  final List<Map<String, dynamic>> doctors = [
    {"name": "Dr. Rajesh Kumar", "degree": "MBBS, MD", "patients": 200, "rating": 4.5},
    {"name": "Dr. Priya Menon", "degree": "MBBS, DM (Cardiology)", "patients": 150, "rating": 4.2},
    {"name": "Dr. Amit Desai", "degree": "MBBS, DM", "patients": 180, "rating": 4.7},
    {"name": "Dr. Meena Iyer", "degree": "MBBS, MD (Cardio)", "patients": 120, "rating": 4.3},
    {"name": "Dr. Sanjay Gupta", "degree": "MBBS, FACC", "patients": 220, "rating": 4.6},
    {"name": "Dr. Sneha Patel", "degree": "MBBS, MD", "patients": 170, "rating": 4.4},
    {"name": "Dr. Vikram Rao", "degree": "MBBS, DM (Cardiology)", "patients": 210, "rating": 4.8},
    {"name": "Dr. Ananya Sharma", "degree": "MBBS, MD", "patients": 160, "rating": 4.1},
    {"name": "Dr. Sameer Kapoor", "degree": "MBBS, MD", "patients": 140, "rating": 4.0},
    {"name": "Dr. Kiran Bedi", "degree": "MBBS, MD (Cardiology)", "patients": 190, "rating": 4.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardiologists', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            elevation: 5,
            color: Colors.lightBlue.shade50, // Mild background color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                doctors[index]['name'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue.shade900, // Softer dark text
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${doctors[index]['degree']} - ${doctors[index]['patients']} patients',
                    style: TextStyle(color: Colors.lightBlue.shade700),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: _buildExactStarRating(doctors[index]['rating']),
                  ),
                ],
              ),
              trailing: Text(
                '${doctors[index]['rating'].toStringAsFixed(1)}', // Display the rating value next to the stars
                style: TextStyle(fontSize: 16, color: Colors.lightBlue.shade700),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(doctor: doctors[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildExactStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor(); // Get number of full stars
    double partialStar = rating - fullStars; // Get fractional part for partial star

    for (int i = 1; i <= 5; i++) {
      if (i <= fullStars) {
        // Add fully filled star
        stars.add(Icon(Icons.star, color: Colors.amber));
      } else if (i == fullStars + 1 && partialStar > 0) {
        // Add partially filled star
        stars.add(_buildPartialStar(partialStar));
      } else {
        // Add empty star
        stars.add(Icon(Icons.star_border, color: Colors.amber));
      }
    }
    return stars;
  }

  Widget _buildPartialStar(double fillPercentage) {
    return Stack(
      children: [
        Icon(
          Icons.star_border,
          color: Colors.amber,
        ),
        ClipRect(
          clipper: _PartialStarClipper(fillPercentage),
          child: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}

class _PartialStarClipper extends CustomClipper<Rect> {
  final double fillPercentage; // Fill percentage (e.g., 0.2 for 20% fill)

  _PartialStarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width * fillPercentage, size.height);
  }

  @override
  bool shouldReclip(_PartialStarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  BookingPage({required this.doctor});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _bookAppointment() {
    if (selectedDate != null && selectedTime != null) {
      final snackBar = SnackBar(
        content: Text('Appointment booked for ${widget.doctor['name']} on ${selectedDate!.toLocal()} at ${selectedTime!.format(context)}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text('Please select both date and time!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue.shade50, // Mild background color for the appointment details page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking with ${widget.doctor['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlue.shade900),
            ),
            SizedBox(height: 20),
            Text('Select Date:', style: TextStyle(color: Colors.lightBlue.shade700)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(selectedDate == null
                  ? 'Choose Date'
                  : '${selectedDate!.toLocal()}'.split(' ')[0]),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade400),
            ),
            SizedBox(height: 20),
            Text('Select Time:', style: TextStyle(color: Colors.lightBlue.shade700)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(selectedTime == null
                  ? 'Choose Time'
                  : selectedTime!.format(context)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade400),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                child: Text('Book Appointment'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade600),
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
    home: DoctorPage(),
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
    ),
  ));
}
