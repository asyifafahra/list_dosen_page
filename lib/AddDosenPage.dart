import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDosenPage extends StatefulWidget {
  const AddDosenPage({super.key});

  @override
  State<AddDosenPage> createState() => _AddDosenPageState();
}

class _AddDosenPageState extends State<AddDosenPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.1.41:8000/api/dosen'),
        body: {
          'nama_lengkap': namaController.text,
          'nip': nipController.text,
          'no_telepon': teleponController.text,
          'email': emailController.text,
          'alamat': alamatController.text,
        },
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true); // ✅ Kirim sinyal berhasil ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal menambahkan dosen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Dosen"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan nama lengkap' : null,
              ),
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) => value!.isEmpty ? 'Masukkan NIP' : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
