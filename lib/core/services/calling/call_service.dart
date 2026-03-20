/// Call service — handles emergency phone calls via url_launcher.
class CallService {
  /// Initiate an emergency call to the given phone number.
  /// Emergency call must route within 3 seconds.
  /// Call rerouting OFF = no call is made during emergency.
  Future<void> callEmergencyNumber(String number) async {
    // TODO: implement using url_launcher
    // final uri = Uri(scheme: 'tel', path: number);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // }
  }
}
