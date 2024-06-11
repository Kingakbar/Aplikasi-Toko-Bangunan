class Barang {
  final String kdBarang;
  final String namaBarang;
  final int idJenis;
  final String satuan;
  final int stok;
  final int hargaPokok;
  final int hargaJual;
  final int markup;
  final JenisBarang jenisBarang;
  int quantity;

  Barang({
    required this.kdBarang,
    required this.namaBarang,
    required this.idJenis,
    required this.satuan,
    required this.stok,
    required this.hargaPokok,
    required this.hargaJual,
    required this.markup,
    required this.jenisBarang,
    this.quantity = 1,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kdBarang: json['kd_barang'],
      namaBarang: json['nama_barang'],
      idJenis: int.parse(json['id_jenis']),
      satuan: json['satuan'],
      stok: int.parse(json['stok']),
      hargaPokok: int.parse(json['harga_pokok']),
      hargaJual: int.parse(json['harga_jual']),
      markup: int.parse(json['markup']),
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
    int? hargaJual,
    int? markup,
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
      hargaJual: hargaJual ?? this.hargaJual,
      jenisBarang: jenisBarang ?? this.jenisBarang,
      markup: markup ?? this.markup,
      quantity: quantity ?? this.quantity,
    );
  }
}

class JenisBarang {
  final String namaJenis;
  final int idJenis;

  JenisBarang({
    required this.namaJenis,
    required this.idJenis,
  });

  factory JenisBarang.fromJson(Map<String, dynamic> json) {
    return JenisBarang(
      idJenis: int.parse(json['id_jenis']),
      namaJenis: json['nama_jenis'],
    );
  }
}
