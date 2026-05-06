import 'package:flutter/material.dart';

import 'package:mobile/src/models/profile.dart';
import 'package:mobile/src/models/session_user.dart';
import 'package:mobile/src/services/profile_service.dart';
import 'package:mobile/src/widgets/app_async_view.dart';
import 'package:mobile/src/config/injector.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });

  final SessionUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  Profile? _profile;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _academicDegreeController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryCoefficientController = TextEditingController();
  final _salaryController = TextEditingController();
  final _reductionPercentController = TextEditingController();
  final _reductionReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    _academicDegreeController.dispose();
    _positionController.dispose();
    _salaryCoefficientController.dispose();
    _salaryController.dispose();
    _reductionPercentController.dispose();
    _reductionReasonController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await getIt<ProfileService>().getProfile(widget.user);
      _profile = profile;
      _fullNameController.text = profile.fullName;
      _dateOfBirthController.text = profile.dateOfBirth;
      _academicDegreeController.text = profile.academicDegree;
      _positionController.text = profile.position;
      _salaryCoefficientController.text = profile.salaryCoefficient;
      _salaryController.text = profile.salary;
      _reductionPercentController.text = profile.reductionPercent;
      _reductionReasonController.text = profile.reductionReason;
    } catch (error) {
      _error = error.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _profile == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = _profile!.copyWith(
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
        academicDegree: _academicDegreeController.text.trim(),
        position: _positionController.text.trim(),
        salaryCoefficient: _salaryCoefficientController.text.trim(),
        salary: _salaryController.text.trim(),
        reductionPercent: _reductionPercentController.text.trim(),
        reductionReason: _reductionReasonController.text.trim(),
      );

      final saved = await getIt<ProfileService>().updateProfile(updated, widget.user);
      setState(() {
        _profile = saved;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: AppAsyncView(
        isLoading: _isLoading,
        error: _error,
        onRetry: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (_profile != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile!.username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Phòng ban: ${_profile!.departmentCode}'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        controller: _fullNameController,
                        label: 'Họ và tên',
                      ),
                      _buildField(
                        controller: _dateOfBirthController,
                        label: 'Ngày sinh',
                        hintText: 'YYYY-MM-DD',
                      ),
                      _buildField(
                        controller: _academicDegreeController,
                        label: 'Học vị',
                      ),
                      _buildField(
                        controller: _positionController,
                        label: 'Chức vụ',
                      ),
                      _buildField(
                        controller: _salaryCoefficientController,
                        label: 'Hệ số lương',
                      ),
                      _buildField(
                        controller: _salaryController,
                        label: 'Lương',
                      ),
                      _buildField(
                        controller: _reductionPercentController,
                        label: 'Phần trăm giảm trừ',
                      ),
                      _buildField(
                        controller: _reductionReasonController,
                        label: 'Lý do giảm trừ',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSaving ? null : _save,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Lưu thông tin'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label là bắt buộc';
          }
          return null;
        },
      ),
    );
  }
}
