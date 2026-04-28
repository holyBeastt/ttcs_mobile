import '../models/guest_lecturer.dart';
import 'api_client.dart';

class GuestLecturerService {
  GuestLecturerService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<GuestLecturer>> getGuestLecturers({
    String keyword = '',
  }) async {
    final waitingResponse = await _apiClient.get(
      '/api/gvm/waiting-list/data',
      queryParameters: {
        'khoa': 'ALL',
        'checkOrder': 'ALL',
      },
    );
    final checkedResponse = await _apiClient.get(
      '/api/gvm/checked-list/data',
      queryParameters: {
        'khoa': 'ALL',
      },
    );

    final merged = <int, GuestLecturer>{};
    for (final item in [
      ..._extractList(waitingResponse),
      ..._extractList(checkedResponse),
    ]) {
      final lecturer = GuestLecturer.fromJson(item);
      merged[lecturer.id] = lecturer;
    }

    final normalizedKeyword = keyword.trim().toLowerCase();
    final results = merged.values.where((item) {
      if (normalizedKeyword.isEmpty) return true;
      return item.fullName.toLowerCase().contains(normalizedKeyword) ||
          item.mainSubject.toLowerCase().contains(normalizedKeyword) ||
          item.departmentCode.toLowerCase().contains(normalizedKeyword);
    }).toList();

    results.sort((a, b) => a.fullName.compareTo(b.fullName));
    return results;
  }

  Future<GuestLecturer?> getGuestLecturerDetail(int id) async {
    final items = await getGuestLecturers();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }
}
