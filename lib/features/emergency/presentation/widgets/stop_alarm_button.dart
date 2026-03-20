import 'package:flutter/material.dart';
class StopAlarmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const StopAlarmButton({super.key, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(200, 56)),
      child: const Text('STOP ALARM', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
