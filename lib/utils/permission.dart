import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class PermissionHandler {
  static Future<bool> checkInternetConnectivity(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content: Text(
                'This app requires an internet connection to function properly. Please connect to the internet and try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }
}
