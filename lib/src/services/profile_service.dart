import '../models/session_user.dart';
import '../models/profile.dart';
import 'api_client.dart';

class ProfileService {
  ProfileService(this._apiClient);

  final ApiClient _apiClient;

  Future<Profile> getProfile(SessionUser user) async {
    final html = await _apiClient.getText('/infome/${user.id}');
    return _parseProfileFromHtml(html, user);
  }

  Future<Profile> updateProfile(Profile profile, SessionUser user) async {
    final response = await _apiClient.post(
      '/infome/${user.id}',
      body: profile.toWebUpdatePayload(user),
    );

    if (response is Map<String, dynamic> && response['message'] != null) {
      return profile;
    }

    throw const ApiException('Profile update failed');
  }

  Profile _parseProfileFromHtml(String html, SessionUser user) {
    return Profile(
      fullName: _matchValue(html, 'TenNhanVien') ?? user.fullName,
      dateOfBirth: _matchValue(html, 'NgaySinh') ?? '',
      academicDegree: _matchSelectedOption(html, 'HocVi') ?? '',
      position: _matchValue(html, 'ChucVu') ?? '',
      salaryCoefficient: _matchValue(html, 'HSL') ?? '',
      salary: _matchValue(html, 'Luong') ?? '',
      reductionPercent: _matchValue(html, 'PhanTramMienGiam') ?? '',
      reductionReason: _matchSelectedOption(html, 'LyDo') ??
          _matchScriptConstant(html, 'LyDo') ??
          '',
      departmentCode: user.departmentCode,
      username: user.username,
    );
  }

  String? _matchValue(String html, String fieldName) {
    final pattern = RegExp(
      'name="$fieldName"[^>]*value="([^"]*)"',
      caseSensitive: false,
      dotAll: true,
    );
    return pattern.firstMatch(html)?.group(1)?.trim();
  }

  String? _matchSelectedOption(String html, String selectName) {
    final selectPattern = RegExp(
      'name="$selectName"[^>]*>(.*?)</select>',
      caseSensitive: false,
      dotAll: true,
    );
    final selectContent = selectPattern.firstMatch(html)?.group(1);
    if (selectContent == null) return null;

    final selectedPattern = RegExp(
      '<option[^>]*value="([^"]*)"[^>]*selected',
      caseSensitive: false,
      dotAll: true,
    );
    return selectedPattern.firstMatch(selectContent)?.group(1)?.trim();
  }

  String? _matchScriptConstant(String html, String constantName) {
    final pattern = RegExp(
      'const\\s+$constantName\\s*=\\s*"([^"]*)"',
      caseSensitive: false,
      dotAll: true,
    );
    return pattern.firstMatch(html)?.group(1)?.trim();
  }
}
