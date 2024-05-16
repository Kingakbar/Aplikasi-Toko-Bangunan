class JenisBarang {
  final int idJenis;
  final String namaJenis;

  JenisBarang({
    required this.idJenis,
    required this.namaJenis,
  });

  factory JenisBarang.fromJson(Map<String, dynamic> json) {
    return JenisBarang(
      idJenis: json['id_jenis'],
      namaJenis: json['nama_jenis'],
    );
  }
}

class Barang {
  final String kdBarang;
  final String namaBarang;
  final int idJenis;
  final String satuan;
  final int stok;
  final int hargaPokok;
  final int ppn;
  final int hargaJual;
  final JenisBarang jenisBarang;
  int quantity;

  Barang({
    required this.kdBarang,
    required this.namaBarang,
    required this.idJenis,
    required this.satuan,
    required this.stok,
    required this.hargaPokok,
    required this.ppn,
    required this.hargaJual,
    required this.jenisBarang,
    this.quantity = 1,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kdBarang: json['kd_barang'],
      namaBarang: json['nama_barang'],
      idJenis: json['id_jenis'],
      satuan: json['satuan'],
      stok: json['stok'],
      hargaPokok: json['harga_pokok'],
      ppn: json['ppn'],
      hargaJual: json['harga_jual'],
      jenisBarang: JenisBarang.fromJson(json['jenis_barang']),
    );
  }

  Barang copyWith({
    String? kdBarang,
    String? namaBarang,
    int? idJenis,
    String? satuan,
    int? stok,
    int? hargaPokok,
    int? ppn,
    int? hargaJual,
    JenisBarang? jenisBarang,
    int? quantity,
  }) {
    return Barang(
      kdBarang: kdBarang ?? this.kdBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      idJenis: idJenis ?? this.idJenis,
      satuan: satuan ?? this.satuan,
      stok: stok ?? this.stok,
      hargaPokok: hargaPokok ?? this.hargaPokok,
      ppn: ppn ?? this.ppn,
      hargaJual: hargaJual ?? this.hargaJual,
      jenisBarang: jenisBarang ?? this.jenisBarang,
      quantity: quantity ?? this.quantity,
    );
  }
}
