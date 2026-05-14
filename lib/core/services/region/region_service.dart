import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:keep')
class RegionService {
  static const String _emergencyNumberKey = 'emergency_number';
  static const String _secondaryEmergencyNameKey = 'secondary_emergency_name';
  static const String _secondaryEmergencyNumberKey = 'secondary_emergency_number';
  static const String _countryKey = 'detected_country';
  static const String _regionKey = 'detected_region';

  final SharedPreferences _prefs;
  RegionService(this._prefs);

  Future<void> detectAndSaveRegion() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // low accuracy is fine for country detection
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return;

      final place = placemarks.first;
      final country = place.country ?? '';
      final isoCountry = place.isoCountryCode ?? '';
      final adminArea = place.administrativeArea ?? ''; // state/region

      await _prefs.setString(_countryKey, country);
      await _prefs.setString(_regionKey, adminArea);

      final numbers = _getEmergencyNumbers(isoCountry, adminArea);
      await _prefs.setString(_emergencyNumberKey, numbers.primary);
      await _prefs.setString(_secondaryEmergencyNameKey, numbers.secondaryName);
      await _prefs.setString(_secondaryEmergencyNumberKey, numbers.secondary);

    } catch (e) {
      // Fallback to international defaults if detection fails
      await _prefs.setString(_emergencyNumberKey, '112');
      await _prefs.setString(_secondaryEmergencyNameKey, 'Local Emergency');
      await _prefs.setString(_secondaryEmergencyNumberKey, '911');
    }
  }

  EmergencyNumbers getEmergencyNumbers() {
    return EmergencyNumbers(
      primary: _prefs.getString(_emergencyNumberKey) ?? '112',
      secondaryName: _prefs.getString(_secondaryEmergencyNameKey) ?? 'Local Emergency',
      secondary: _prefs.getString(_secondaryEmergencyNumberKey) ?? '911',
    );
  }

  String get detectedCountry => _prefs.getString(_countryKey) ?? '';
  String get detectedRegion => _prefs.getString(_regionKey) ?? '';

  EmergencyNumbers _getEmergencyNumbers(String isoCountry, String adminArea) {
    switch (isoCountry.toUpperCase()) {

      // ── NIGERIA ──────────────────────────────────────────────
      case 'NG':
        final state = adminArea.toLowerCase();
        // Lagos
        if (state.contains('lagos')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'LASEMA', secondary: '767');
        }
        // Abuja (FCT)
        if (state.contains('abuja') || state.contains('federal capital')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'AESA', secondary: '112');
        }
        // Kano
        if (state.contains('kano')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Kano Emergency', secondary: '080-3960-2601');
        }
        // Rivers (Port Harcourt)
        if (state.contains('rivers')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Rivers Emergency', secondary: '112');
        }
        // Oyo (Ibadan)
        if (state.contains('oyo')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Oyo Emergency', secondary: '112');
        }
        // Ogun
        if (state.contains('ogun')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Ogun Emergency', secondary: '112');
        }
        // Anambra
        if (state.contains('anambra')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Anambra Emergency', secondary: '112');
        }
        // Delta
        if (state.contains('delta')) {
          return const EmergencyNumbers(primary: '112', secondaryName: 'Delta Emergency', secondary: '112');
        }
        // Default Nigeria
        return const EmergencyNumbers(primary: '112', secondaryName: 'NEMA', secondary: '0800-CALLNEMA');

      // ── UNITED KINGDOM ───────────────────────────────────────
      case 'GB':
        return const EmergencyNumbers(primary: '999', secondaryName: 'NHS 111', secondary: '111');

      // ── UNITED STATES ────────────────────────────────────────
      case 'US':
        return const EmergencyNumbers(primary: '911', secondaryName: 'Non-Emergency', secondary: '311');

      // ── EUROPE ───────────────────────────────────────────────
      case 'DE': // Germany
        return const EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '110');
      case 'FR': // France
        return const EmergencyNumbers(primary: '15', secondaryName: 'Police', secondary: '17');
      case 'IT': // Italy
        return const EmergencyNumbers(primary: '118', secondaryName: 'Police', secondary: '113');
      case 'ES': // Spain
        return const EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '091');
      case 'NL': // Netherlands
        return const EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '0900-8844');
      case 'BE': // Belgium
        return const EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '101');
      case 'SE': // Sweden
        return const EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '11414');
      case 'NO': // Norway
        return const EmergencyNumbers(primary: '113', secondaryName: 'Police', secondary: '112');
      case 'DK': // Denmark
        return const EmergencyNumbers(primary: '112', secondaryName: 'Non-Emergency', secondary: '114');
      case 'PL': // Poland
        return const EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '997');
      case 'PT': // Portugal
        return const EmergencyNumbers(primary: '112', secondaryName: 'Police', secondary: '112');
      case 'CH': // Switzerland
        return const EmergencyNumbers(primary: '144', secondaryName: 'Police', secondary: '117');
      case 'AT': // Austria
        return const EmergencyNumbers(primary: '144', secondaryName: 'Police', secondary: '133');
      case 'IE': // Ireland
        return const EmergencyNumbers(primary: '999', secondaryName: 'Alternative', secondary: '112');

      // ── AFRICA ───────────────────────────────────────────────
      case 'GH': // Ghana
        return const EmergencyNumbers(primary: '999', secondaryName: 'Ambulance', secondary: '193');
      case 'KE': // Kenya
        return const EmergencyNumbers(primary: '999', secondaryName: 'Ambulance', secondary: '1199');
      case 'ZA': // South Africa
        return const EmergencyNumbers(primary: '10111', secondaryName: 'Ambulance', secondary: '10177');
      case 'EG': // Egypt
        return const EmergencyNumbers(primary: '123', secondaryName: 'Police', secondary: '122');
      case 'ET': // Ethiopia
        return const EmergencyNumbers(primary: '911', secondaryName: 'Police', secondary: '991');

      // ── AMERICAS ─────────────────────────────────────────────
      case 'CA': // Canada
        return const EmergencyNumbers(primary: '911', secondaryName: 'Non-Emergency', secondary: '311');
      case 'MX': // Mexico
        return const EmergencyNumbers(primary: '911', secondaryName: 'Red Cross', secondary: '065');
      case 'BR': // Brazil
        return const EmergencyNumbers(primary: '190', secondaryName: 'Ambulance', secondary: '192');
      case 'AR': // Argentina
        return const EmergencyNumbers(primary: '911', secondaryName: 'Fire', secondary: '100');

      // ── ASIA-PACIFIC ─────────────────────────────────────────
      case 'AU': // Australia
        return const EmergencyNumbers(primary: '000', secondaryName: 'Non-Emergency', secondary: '131 444');
      case 'IN': // India
        return const EmergencyNumbers(primary: '112', secondaryName: 'Ambulance', secondary: '108');
      case 'JP': // Japan
        return const EmergencyNumbers(primary: '119', secondaryName: 'Police', secondary: '110');
      case 'CN': // China
        return const EmergencyNumbers(primary: '120', secondaryName: 'Police', secondary: '110');
      case 'SG': // Singapore
        return const EmergencyNumbers(primary: '995', secondaryName: 'Police', secondary: '999');
      case 'AE': // UAE
        return const EmergencyNumbers(primary: '998', secondaryName: 'Police', secondary: '999');
      case 'SA': // Saudi Arabia
        return const EmergencyNumbers(primary: '911', secondaryName: 'Police', secondary: '999');
      case 'PK': // Pakistan
        return const EmergencyNumbers(primary: '115', secondaryName: 'Police', secondary: '15');
      case 'NZ': // New Zealand
        return const EmergencyNumbers(primary: '111', secondaryName: 'Non-Emergency', secondary: '105');

      // ── INTERNATIONAL FALLBACK ────────────────────────────────
      default:
        return const EmergencyNumbers(primary: '112', secondaryName: 'Local Emergency', secondary: '911');
    }
  }
}

class EmergencyNumbers {
  final String primary;          // e.g. "112"
  final String secondaryName;   // e.g. "LASEMA"
  final String secondary;       // e.g. "767"

  const EmergencyNumbers({
    required this.primary,
    required this.secondaryName,
    required this.secondary,
  });
}
