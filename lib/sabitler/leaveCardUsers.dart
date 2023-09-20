import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveCardU extends StatelessWidget {
  final String izinTipi;
  final String izinGunSayisi;
  final Timestamp selectedBaslangicTarihi;
  final Timestamp selectedBitisTarihi;
  final String izinAlmaNedeni;
  final String name;
  final String department;
    final String onay;
  final VoidCallback onDelete;

  const LeaveCardU({
    Key? key,
    required this.izinTipi,
    required this.izinGunSayisi,
    required this.selectedBaslangicTarihi,
    required this.selectedBitisTarihi,
    required this.izinAlmaNedeni,
    required this.name,
    required this.department,
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
            Text('Onay Durumu: $onay'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Arka plan rengi
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
