class Supplier {
  final String? kdSupplier; // Make kdSupplier nullable

  final String namaSupplier;
  final String alamatSupplier;
  final String noTelpSupplier;

  Supplier({
    this.kdSupplier, // Make kdSupplier optional
    required this.namaSupplier,
    required this.alamatSupplier,
    required this.noTelpSupplier,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      kdSupplier: json['kd_supplier'],
      namaSupplier: json['nama_supplier'],
      alamatSupplier: json['alamat_supplier'],
      noTelpSupplier: json['no_telp_supplier'],
    );
  }
}
