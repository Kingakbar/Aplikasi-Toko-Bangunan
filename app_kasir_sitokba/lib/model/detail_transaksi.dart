class TransaksiDetail {
  final int id;
  final int noTransaksi;
  final String kdBarang;
  final String barang;
  final int harga;
  final int banyak;
  final int total;

  TransaksiDetail({
    required this.id,
    required this.noTransaksi,
    required this.kdBarang,
    required this.barang,
    required this.harga,
    required this.banyak,
    required this.total,
  });

  factory TransaksiDetail.fromJson(Map<String, dynamic> json) {
    return TransaksiDetail(
      id: json['id'],
      noTransaksi: json['no_transaksi'],
      kdBarang: json['kd_barang'],
      barang: json['barang'],
      harga: json['harga'],
      banyak: json['banyak'],
      total: json['total'],
    );
  }
}
