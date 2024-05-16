class Jenis {
  final String namaJenis;
  final int? idJenis; // Mengubah tipe menjadi int?

  Jenis({
    required this.namaJenis,
    this.idJenis, // Membuat idJenis menjadi nullable dengan tanda tanya (?)
  });

  factory Jenis.fromJson(Map<String, dynamic>? json) {
    return Jenis(
      idJenis: json?['id_jenis'],
      namaJenis: json?['nama_jenis'] ?? '',
    );
  }
}
