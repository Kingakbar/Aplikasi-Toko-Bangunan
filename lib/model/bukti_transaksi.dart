class BuktiTransaksi {
  final String noTransaksi;
  final String? gambar;

  BuktiTransaksi({
    required this.noTransaksi,
    this.gambar,
  });

  factory BuktiTransaksi.fromJson(Map<String, dynamic> json) {
    return BuktiTransaksi(
      noTransaksi: json['no_transaksi'],
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_transaksi': noTransaksi,
      'gambar': gambar,
    };
  }
}
