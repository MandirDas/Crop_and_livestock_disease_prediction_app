import 'package:FarmVeda/views/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:frontend/utils/permission.dart';

// import 'permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _determinePosition();
  runApp(MyApp());
}

Future<void> _determinePosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) {
    // Handle the case when the user denies the permission permanently
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enbow',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
