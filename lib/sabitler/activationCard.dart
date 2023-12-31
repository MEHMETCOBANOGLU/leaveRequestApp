import 'package:flutter/material.dart';

class ActivationCard extends StatelessWidget {
  final String name;
  final String department;
  final String email;
  final String rool;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ActivationCard({
    Key? key,
    required this.name,
    required this.department,
    required this.email,
    required this.rool,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Color.fromARGB(255, 205, 241, 247),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$name',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue[400]),
            ),
            Text('e-mail: $email'),
            Text('rol: $rool'),
            SizedBox(height: 8), 
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, 
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 246, 78)), 
                  ),
                  onPressed: onApprove,
                  child: Text('Aktivasyon',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
                SizedBox(width: 8), 
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red), 
                  ),
                  onPressed: onReject,
                  child: Text('Reddet',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
                SizedBox(width: 8), 
              ],
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
