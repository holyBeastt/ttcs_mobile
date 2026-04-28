class SessionUser {
  const SessionUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.departmentCode,
    required this.isFaculty,
  });

  final int id;
  final String username;
  final String fullName;
  final String role;
  final String departmentCode;
  final bool isFaculty;

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: _toInt(json['id'] ?? json['id_User']),
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['TenNhanVien']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString() ?? json['MaPhongBan']?.toString() ?? '',
      isFaculty: json['isFaculty'] == true ||
          json['isFaculty'] == 1 ||
          json['isKhoa'] == true ||
          json['isKhoa'] == 1,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
