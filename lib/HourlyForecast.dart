import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
   HourlyForecastItem({
    required this.time,
    required this.icon,
    required this.temperature,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 6,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child:  Column(
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Icon(
                              icon,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(temperature),
                          ],
                        ),
                      ),
                    );
  }
}
