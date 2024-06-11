class Transaksi {
  final int idTransaksi;
  final String noTransaksi;
  final DateTime tglTransaksi;
  final int subtotal;
  final int diskon;
  final int totalAkhir;
  final int bayar;
  final int kembalian;
  final int userId;
  final String status;
  final String userName;
  final List<DetailTransaksi> transaksiDetail;
  final String? gambar; // Nullable

  Transaksi({
    required this.idTransaksi,
    required this.noTransaksi,
    required this.tglTransaksi,
    required this.subtotal,
    required this.diskon,
    required this.totalAkhir,
    required this.bayar,
    required this.kembalian,
    required this.userId,
    required this.status,
    required this.userName,
    required this.transaksiDetail,
    this.gambar, // Nullable
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: int.parse(json['id'].toString()),
      noTransaksi: json['no_transaksi'],
      tglTransaksi: DateTime.parse(json['tgl_transaksi']),
      subtotal: int.parse(json['subtotal'].toString()),
      diskon: int.parse(json['diskon'].toString()),
      totalAkhir: int.parse(json['total_akhir'].toString()),
      bayar: int.parse(json['bayar'].toString()),
      kembalian: int.parse(json['kembalian'].toString()),
      userId: int.parse(json['user_id'].toString()),
      status: json['status'],
      userName: json['user']['nama_user'],
      transaksiDetail: List<DetailTransaksi>.from(
          json['transaksi_detail'].map((x) => DetailTransaksi.fromJson(x))),
      gambar: json['bukti_transaksi'] != null
          ? json['bukti_transaksi']['gambar']
          : null,
    );
  }
}

class DetailTransaksi {
  final String kdBarang;
  final String namaBarang;
  final String satuan;
  final int stok;
  final int hargaPokok;
  final int hargaJual;
  final int markup;
  final int harga;
  final int banyak;
  final int total;

  DetailTransaksi({
    required this.kdBarang,
    required this.namaBarang,
    required this.satuan,
    required this.stok,
    required this.hargaPokok,
    required this.hargaJual,
    required this.markup,
    required this.harga,
    required this.banyak,
    required this.total,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      kdBarang: json['kd_barang'],
      namaBarang: json['barang']['nama_barang'],
      satuan: json['barang']['satuan'],
      stok: int.parse(json['barang']['stok'].toString()),
      hargaPokok: int.parse(json['barang']['harga_pokok'].toString()),
      hargaJual: int.parse(json['barang']['harga_jual'].toString()),
      markup: int.parse(json['barang']['markup'].toString()),
      harga: int.parse(json['harga'].toString()),
      banyak: int.parse(json['banyak'].toString()),
      total: int.parse(json['total'].toString()),
    );
  }
}
