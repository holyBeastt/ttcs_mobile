import 'package:mobile/src/models/session_user.dart';

class Profile {
  const Profile({
    required this.fullName,
    required this.dateOfBirth,
    required this.academicDegree,
    required this.position,
    required this.salaryCoefficient,
    required this.salary,
    required this.reductionPercent,
    required this.reductionReason,
    required this.departmentCode,
    required this.username,
  });

  final String fullName;
  final String dateOfBirth;
  final String academicDegree;
  final String position;
  final String salaryCoefficient;
  final String salary;
  final String reductionPercent;
  final String reductionReason;
  final String departmentCode;
  final String username;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      fullName: json['fullName']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      academicDegree: json['academicDegree']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
      salaryCoefficient: json['salaryCoefficient']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      reductionPercent: json['reductionPercent']?.toString() ?? '',
      reductionReason: json['reductionReason']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toWebUpdatePayload(SessionUser user) {
    return {
      'Id_User': user.id.toString(),
      'TenDangNhap': user.username,
      'Quyen': user.role,
      'TenNhanVien': fullName,
      'NgaySinh': dateOfBirth,
      'HocVi': academicDegree,
      'ChucVu': position,
      'HSL': salaryCoefficient,
      'Luong': salary,
      'PhanTramMienGiam': reductionPercent,
      'LyDo': reductionReason,
    };
  }

  Profile copyWith({
    String? fullName,
    String? dateOfBirth,
    String? academicDegree,
    String? position,
    String? salaryCoefficient,
    String? salary,
    String? reductionPercent,
    String? reductionReason,
    String? departmentCode,
    String? username,
  }) {
    return Profile(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      academicDegree: academicDegree ?? this.academicDegree,
      position: position ?? this.position,
      salaryCoefficient: salaryCoefficient ?? this.salaryCoefficient,
      salary: salary ?? this.salary,
      reductionPercent: reductionPercent ?? this.reductionPercent,
      reductionReason: reductionReason ?? this.reductionReason,
      departmentCode: departmentCode ?? this.departmentCode,
      username: username ?? this.username,
    );
  }
}
