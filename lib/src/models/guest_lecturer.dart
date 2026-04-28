class GuestLecturer {
  const GuestLecturer({
    required this.id,
    required this.fullName,
    required this.departmentCode,
    required this.academicDegree,
    required this.position,
    required this.mainSubject,
    required this.teachingStatus,
    required this.approvalStatus,
    required this.phone,
    this.contractSummary,
  });

  final int id;
  final String fullName;
  final String departmentCode;
  final String academicDegree;
  final String position;
  final String mainSubject;
  final String teachingStatus;
  final String approvalStatus;
  final String phone;
  final String? contractSummary;

  factory GuestLecturer.fromJson(Map<String, dynamic> json) {
    final khoaDuyet = _toInt(json['khoa_duyet']);
    final daoTaoDuyet = _toInt(json['dao_tao_duyet']);
    final hocVienDuyet = _toInt(json['hoc_vien_duyet']);

    return GuestLecturer(
      id: _toInt(json['id'] ?? json['id_Gvm']),
      fullName: json['fullName']?.toString() ?? json['HoTen']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString() ?? json['MaPhongBan']?.toString() ?? '',
      academicDegree: json['academicDegree']?.toString() ?? json['HocVi']?.toString() ?? '',
      position: json['position']?.toString() ?? json['ChucVu']?.toString() ?? '',
      mainSubject: json['mainSubject']?.toString() ?? json['MonGiangDayChinh']?.toString() ?? '',
      teachingStatus: json['teachingStatus']?.toString() ??
          (_toInt(json['TinhTrangGiangDay']) == 1 ? 'Active' : 'Stopped'),
      approvalStatus: json['approvalStatus']?.toString() ??
          _buildApprovalStatus(khoaDuyet, daoTaoDuyet, hocVienDuyet),
      phone: json['phone']?.toString() ?? json['DienThoai']?.toString() ?? '',
      contractSummary: json['contractSummary']?.toString() ?? json['MaGvm']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _buildApprovalStatus(int khoaDuyet, int daoTaoDuyet, int hocVienDuyet) {
    if (hocVienDuyet == 1) return 'Approved';
    if (daoTaoDuyet == 1) return 'Approved by training';
    if (khoaDuyet == 1) return 'Approved by faculty';
    return 'Pending';
  }
}
