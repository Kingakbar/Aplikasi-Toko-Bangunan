class BarangMasuk {
  final String kdSupplier;
  final String kdBarang;
  final String namaBarang;
  final String satuan;
  final int harga;
  final int jumlah;
  final int totalHarga;
  final String tanggal;
  final Supplier? supplier;
  final Barang? barang;

  BarangMasuk({
    required this.kdSupplier,
    required this.kdBarang,
    required this.namaBarang,
    required this.satuan,
    required this.harga,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
    this.supplier,
    this.barang,
  });

  factory BarangMasuk.fromJson(Map<String, dynamic> json) {
    return BarangMasuk(
      kdSupplier: json['kd_supplier'],
      kdBarang: json['kd_barang'],
      namaBarang: json['nama_barang'],
      satuan: json['satuan'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      totalHarga: json['total_harga'],
      tanggal: json['tanggal'],
      supplier: Supplier.fromJson(json['supplier']),
      barang: Barang.fromJson(json['barang']),
    );
  }
}

class Supplier {
  final String kdSupplier;
  final String namaSupplier;

  Supplier({
    required this.kdSupplier,
    required this.namaSupplier,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      kdSupplier: json['kd_supplier'],
      namaSupplier: json['nama_supplier'],
    );
  }
}

class Barang {
  final String kdBarang;
  final String namaBarang;

  Barang({
    required this.kdBarang,
    required this.namaBarang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kdBarang: json['kd_barang'],
      namaBarang: json['nama_barang'],
    );
  }
}
