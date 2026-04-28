class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.departmentCode,
    this.deadline,
    this.expired = false,
  });

  final int id;
  final String title;
  final String message;
  final String departmentCode;
  final DateTime? deadline;
  final bool expired;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? json['Title']?.toString() ?? '',
      message: json['message']?.toString() ?? json['LoiNhan']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString() ?? json['MaPhongBan']?.toString() ?? '',
      deadline: DateTime.tryParse(
        json['deadline']?.toString() ?? json['Deadline']?.toString() ?? '',
      ),
      expired: json['expired'] == true ||
          json['expired'] == 1 ||
          json['HetHan'] == true ||
          json['HetHan'] == 1,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
