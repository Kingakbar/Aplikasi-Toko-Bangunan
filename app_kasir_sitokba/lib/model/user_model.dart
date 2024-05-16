class UserModel {
  String namaUser;
  String jkUser;
  String alamatUser;
  String noTelpUser;
  String username;
  int? id;
  String? accessToken;

  UserModel({
    required this.namaUser,
    required this.jkUser,
    required this.alamatUser,
    required this.noTelpUser,
    required this.username,
    this.id,
    this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      namaUser: json['nama_user'],
      jkUser: json['jk_user'],
      alamatUser: json['alamat_user'],
      noTelpUser: json['no_telp_user'],
      username: json['username'],
      id: json['id'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_user': namaUser,
      'jk_user': jkUser,
      'alamat_user': alamatUser,
      'no_telp_user': noTelpUser,
      'username': username,
      if (id != null) 'id': id,
      if (accessToken != null) 'access_token': accessToken,
    };
  }
}
