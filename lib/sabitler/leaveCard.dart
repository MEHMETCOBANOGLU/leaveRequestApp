import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final String izinTipi;
  final String izinGunSayisi;
  final Timestamp selectedBaslangicTarihi;
  final Timestamp selectedBitisTarihi;
  final String izinAlmaNedeni;
  final String name;
  final String department;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onMessage;
  final VoidCallback onDelete;
  final String onay;

  const LeaveCard({
    Key? key,
    required this.izinTipi,
    required this.izinGunSayisi,
    required this.selectedBaslangicTarihi,
    required this.selectedBitisTarihi,
    required this.izinAlmaNedeni,
    required this.name,
    required this.department,
    required this.onApprove,
    required this.onReject,
    required this.onMessage,
    required this.onay,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    DateTime baslangicTarihi = selectedBaslangicTarihi.toDate();
    DateTime bitisTarihi = selectedBitisTarihi.toDate();

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
            Text('Departman: $department'),
            Text('İzin Tipi: $izinTipi'),
            Text('İzin Gün Sayısı: $izinGunSayisi'),
            Text('Başlangıç Tarihi: ${dateFormat.format(baslangicTarihi)}'),
            Text('Bitiş Tarihi: ${dateFormat.format(bitisTarihi)}'),
            Text('İzin Alma Nedeni: $izinAlmaNedeni'),
            Text('Onay: $onay'),
            SizedBox(height: 8), // Add some spacing between text and buttons
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align buttons to the top
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Arka plan rengi
                  ),
                  onPressed: onApprove,
                  child: Text('Onayla',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
                SizedBox(width: 8), // Add some spacing between buttons
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Arka plan rengi
                  ),
                  onPressed: onReject,
                  child: Text('Reddet',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
                SizedBox(width: 8), // Add some spacing between buttons
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Arka plan rengi
                  ),
                  onPressed: onMessage,
                  child: Text('Mesaj',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 0, 0)), // Arka plan rengi
                  ),
                  onPressed: onDelete,
                  child: Text('sil',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
