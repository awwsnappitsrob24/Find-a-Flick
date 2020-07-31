import 'package:maps_launcher/maps_launcher.dart';
import 'package:android_intent/android_intent.dart';

class HelperFunctions {
  // Open Google Maps set to the location query
  static void openGoogleMaps(String destName) {
    MapsLauncher.launchQuery(destName);
  }

  // Prompt user to open location services
  static void enableLocationServices() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }
}
