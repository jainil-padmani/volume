import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volume Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VolumeControlPage(),
    );
  }
}

class VolumeControlPage extends StatefulWidget {
  @override
  _VolumeControlPageState createState() => _VolumeControlPageState();
}

class _VolumeControlPageState extends State<VolumeControlPage> {
  double _speed = 0.0;
  double _currentVolume = 0.0; // Track current volume level
  bool _volumeControlEnabled = false;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _speed = currentLocation.speed ?? 0.0;
        if (_volumeControlEnabled) {
          _adjustVolume();
        }
      });
    });
  }

  void _adjustVolume() {
    double volume = 0.0;
    if (_speed > 0 && _speed < 20) {
      volume = 0.1;
    } else if (_speed >= 20 && _speed < 40) {
      volume = 0.3;
    } else if (_speed >= 40 && _speed < 60) {
      volume = 0.7;
    } else if (_speed >= 60 && _speed <= 80) {
      volume = 1.0;
    } else if (_speed > 80) {
      volume = 0.6;
    }

    setState(() {
      _currentVolume = volume; // Update current volume level
    });

    // Adjust media volume using platform channels
    MethodChannel('volume_control').invokeMethod('setVolume', {'volume': volume});
  }

  void _toggleVolumeControl() {
    setState(() {
      _volumeControlEnabled = !_volumeControlEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volume Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Speed: $_speed'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleVolumeControl,
              child: Text(_volumeControlEnabled ? 'Disable Volume Control' : 'Enable Volume Control'),
            ),
            SizedBox(height: 10), // Add some spacing
            Text('Current Volume: $_currentVolume'), // Display current volume level
          ],
        ),
      ),
    );
  }
}
