import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
   AdditionalInfo({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column( 
      children: [
        const SizedBox(height: 16,),
        Icon(icon, size: 32,),
        const SizedBox(height: 8,),
        Text(
          label,
          style: TextStyle(
            fontSize: 16
          ), 
        ),
        const SizedBox(height: 8,),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ), 
        )
      ],
    );
  }
}

