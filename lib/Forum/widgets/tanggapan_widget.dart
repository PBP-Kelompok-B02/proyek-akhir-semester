import 'package:flutter/material.dart';  // Perlu import flutter material
import 'package:proyek_akhir_semester/Forum/models/forum_data.dart';  // Import untuk model Reply

class TanggapanWidget extends StatelessWidget {
  final Reply tanggapan;  // Ubah Tanggapan menjadi Reply sesuai model Anda

  const TanggapanWidget({
    Key? key,  // Tambahkan key
    required this.tanggapan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),  // Tambahkan const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tanggapan.content),  // Ubah isi menjadi content sesuai model
            Text('Oleh: ${tanggapan.createdBy}'),  // Ubah penulis menjadi createdBy
          ],
        ),
      ),
    );
  }
}