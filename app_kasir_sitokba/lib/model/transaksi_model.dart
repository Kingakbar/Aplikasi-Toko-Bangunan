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
  final List<DetailTransaksi> transaksiDetail; // Perubahan di sini

  Transaksi({
    required this.noTransaksi,
    required this.idTransaksi,
    required this.tglTransaksi,
    required this.subtotal,
    required this.diskon,
    required this.totalAkhir,
    required this.bayar,
    required this.kembalian,
    required this.userId,
    required this.status,
    required this.userName,
    required this.transaksiDetail, // Perubahan di sini
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: json['id'],
      noTransaksi: json['no_transaksi'],
      tglTransaksi: DateTime.parse(json['tgl_transaksi']),
      subtotal: json['subtotal'],
      diskon: json['diskon'],
      totalAkhir: json['total_akhir'],
      bayar: json['bayar'],
      kembalian: json['kembalian'],
      userId: json['user_id'],
      status: json['status'],
      userName: json['user']['nama_user'],
      transaksiDetail: List<DetailTransaksi>.from(json['transaksi_detail']
          .map((x) => DetailTransaksi.fromJson(x))), // Perubahan di sini
    );
  }
}

// Definisikan kelas DetailTransaksi
class DetailTransaksi {
  final String namaBarang;
  final int banyak;

  DetailTransaksi({
    required this.namaBarang,
    required this.banyak,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      namaBarang: json['barang']['nama_barang'],
      banyak: json['banyak'],
    );
  }
}
