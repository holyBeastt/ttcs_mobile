import 'package:mobile/src/models/announcement.dart';
import 'package:mobile/src/services/api_client.dart';

class AnnouncementService {
  AnnouncementService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Announcement>> getAnnouncements(String departmentCode) async {
    final response = await _apiClient.get('/getMessage/$departmentCode');
    final list = _extractList(response);
    return list.map(Announcement.fromJson).toList();
  }

  Future<Announcement?> getAnnouncementDetail(
    String departmentCode,
    int id,
  ) async {
    final items = await getAnnouncements(departmentCode);
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    final data = response is Map<String, dynamic> ? response['Message'] : null;
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }
}
