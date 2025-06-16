import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateDosenPage extends StatefulWidget {
  final String no;

  const UpdateDosenPage({super.key, required this.no});

  @override
  State<UpdateDosenPage> createState() => _UpdateDosenPageState();
}

class _UpdateDosenPageState extends State<UpdateDosenPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDosen();
  }

  Future<void> fetchDosen() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.41:8000/api/dosen/${widget.no}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        namaController.text = data['nama_lengkap'] ?? '';
        teleponController.text = data['no_telepon'] ?? '';
        emailController.text = data['email'] ?? '';
        alamatController.text = data['alamat'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data dosen')),
      );
    }
  }

  Future<void> updateDosen() async {
    final response = await http.put(
      Uri.parse('http://192.168.1.41:8000/api/dosen/${widget.no}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nama_lengkap': namaController.text,
        'no_telepon': teleponController.text,
        'email': emailController.text,
        'alamat': alamatController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data dosen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Dosen'),
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
                value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No Telepon'),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateDosen();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
