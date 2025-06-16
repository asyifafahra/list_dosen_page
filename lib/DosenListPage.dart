import 'package:flutter/material.dart';
import 'package:list_dosen/model/modelDosen.dart';
import 'package:http/http.dart' as http;
import 'package:list_dosen/AddDosenPage.dart';
import 'package:list_dosen/UpdateDosenPage.dart';
import 'dart:convert';

class DosenListPage extends StatefulWidget {
  @override
  _DosenListPageState createState() => _DosenListPageState();
}

class _DosenListPageState extends State<DosenListPage> {
  late Future<List<ModelDosen>> futureDosen;

  @override
  void initState() {
    super.initState();
    futureDosen = fetchDosen();
  }

  Future<List<ModelDosen>> fetchDosen() async {
    final response = await http.get(Uri.parse('http://192.168.1.41:8000/api/dosen'));
    if (response.statusCode == 200) {
      return modelDosenFromJson(response.body);
    } else {
      throw Exception('Gagal memuat data dosen');
    }
  }

  Future<void> deleteDosen(String no) async {
    final response = await http.delete(Uri.parse('http://192.168.1.41:8000/api/dosen/$no'));
    if (response.statusCode == 200) {
      setState(() {
        futureDosen = fetchDosen();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data dosen berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gagal menghapus data dosen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2F5F9),
      body: FutureBuilder<List<ModelDosen>>(
        future: futureDosen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data dosen tidak tersedia'));
          }

          final dosens = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dosens.length,
            itemBuilder: (context, index) {
              final dosen = dosens[index];

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              dosen.namaLengkap,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDosenPage(no: dosen.no.toString()),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  setState(() {
                                    futureDosen = fetchDosen();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('✅ Data dosen berhasil diperbarui')),
                                  );
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteDosen(dosen.no.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('📌 NIP: ${dosen.nip}', style: const TextStyle(fontSize: 14)),
                      Text('📞 ${dosen.noTelepon}', style: const TextStyle(fontSize: 14)),
                      Text('✉️ ${dosen.email}', style: const TextStyle(fontSize: 14)),
                      Text('🏠 ${dosen.alamat}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDosenPage()),
          ).then((result) {
            if (result == true) {
              setState(() {
                futureDosen = fetchDosen();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Data dosen berhasil ditambahkan')),
              );
            }
          });
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
