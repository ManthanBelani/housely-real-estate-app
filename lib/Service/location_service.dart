import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' show LocationAccuracy, Geolocator, Position, LocationPermission;
// other imports...

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  String? _locationMessage;

  Position? get currentPosition => _currentPosition;
  String? get locationMessage => _locationMessage;

  Future<void> getLocationAndSaveToFirebase() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationMessage = 'Location disabled.';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationMessage = 'permission denied.';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // _locationMessage = 'Location permission permanently denied.';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _currentPosition = position;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.subLocality}, ${place.locality}';

        _locationMessage = address.isNotEmpty ? address : 'Address not found';

        // Save to Firebase
        await _saveAddressToFirestore(address);
      } else {
        _locationMessage = 'Address not found';
      }
    } catch (e) {
      _locationMessage = 'Error getting location: $e';
      print('Error getting location: $e');
    }
  }

  Future<void> _saveAddressToFirestore(String address) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.update({
        'address': FieldValue.arrayUnion([address]),
      });

      print('Address saved to Firebase: $address');
    } else {
      print('User not logged in. Cannot save address.');
    }
  }
}