import 'package:geocoding/geocoding.dart';

Future<String?> getLocationName(double latitude,double longitude) async {
  String? locationName;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude);
      
        locationName = placemarks.first.name;
        return locationName;
    
    } catch (e) {
      print('Error fetching location name: $e');
      return 'unknown';
    }
  }