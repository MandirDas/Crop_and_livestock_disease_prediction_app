import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:FarmVeda/model/vet_model.dart';
import 'package:FarmVeda/shared/config.dart';
import 'package:FarmVeda/views/ui/camera.dart';
import 'package:FarmVeda/views/ui/diagnosis_page.dart';
import 'package:FarmVeda/widgets/vetdetailpage.dart';
import 'package:http/http.dart' as http;
// import 'package:frontend/views/ui/image_selection_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<bool> checkServerConnectivity() async {
  print('Checking server connectivity...');
  var connectivityResult = await (Connectivity().checkConnectivity());
  print('Connectivity result: $connectivityResult');

  if (connectivityResult == ConnectivityResult.none) {
    print("No internet connection");
    return false;
  }

  final url = '${Config.serverUrl}/health'; // or another specific endpoint
  print('Attempting to connect to: $url');
  final response = await http.get(Uri.parse(url));
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  return response.statusCode == 200;
}

final List<Veterinarian> veterinarians = [
  Veterinarian(
    name: 'Happy Paws Vet',
    address: '123 Pet Street, Animal City',
    phone: '123-456-7890',
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  Veterinarian(
    name: 'Care for Pets',
    address: '456 Animal Ave, Pet Town',
    phone: '987-654-3210',
    latitude: 37.7849,
    longitude: -122.4094,
  ),
  // Add more veterinarians as needed
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildClickableContainer(
                        'Treatment via Photo',
                        Icons.camera_alt,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageSelectionScreen()),
                          );
                        },
                      ),
                      _buildClickableContainer(
                        'Treatment via Symptom',
                        Icons.healing,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiagnosisPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 180,
                    color: Colors.transparent,
                    child: PageView.builder(
                      itemCount: veterinarians.length,
                      itemBuilder: (context, index) {
                        final veterinarian = veterinarians[index];
                        return Card(
                          color: Colors.white.withOpacity(0.2),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      child: Icon(Icons.pets,
                                          size: 40, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      veterinarian.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VetDetailPage(
                                            veterinarian: veterinarian),
                                      ),
                                    );
                                  },
                                  child: Text('View Vet Details'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white.withOpacity(0.2),
                                    onPrimary: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableContainer(
      String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
