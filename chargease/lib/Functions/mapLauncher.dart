
import 'package:url_launcher/url_launcher.dart';

void launchGoogleMaps(double destinationLatitude, double destinationLongitude) async {
final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
