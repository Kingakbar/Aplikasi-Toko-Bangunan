class Jenis {
  final String namaJenis;
  final int? idJenis;

  Jenis({
    required this.namaJenis,
    this.idJenis,
  });

  factory Jenis.fromJson(Map<String, dynamic>? json) {
    return Jenis(
      idJenis: json?['id_jenis'] != null
          ? int.tryParse(json!['id_jenis'].toString())
          : null,
      namaJenis: json?['nama_jenis'] ?? '',
    );
  }
}
