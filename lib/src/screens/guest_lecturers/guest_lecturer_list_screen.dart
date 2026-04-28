import 'package:flutter/material.dart';

import '../../models/guest_lecturer.dart';
import '../../services/guest_lecturer_service.dart';
import '../../widgets/app_async_view.dart';

class GuestLecturerListScreen extends StatefulWidget {
  const GuestLecturerListScreen({
    super.key,
    required this.service,
  });

  final GuestLecturerService service;

  @override
  State<GuestLecturerListScreen> createState() =>
      _GuestLecturerListScreenState();
}

class _GuestLecturerListScreenState extends State<GuestLecturerListScreen> {
  final _searchController = TextEditingController();

  bool _isLoading = true;
  String? _error;
  List<GuestLecturer> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = await widget.service.getGuestLecturers(
        keyword: _searchController.text.trim(),
      );
      setState(() {
        _items = items;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDetail(GuestLecturer item) async {
    final detail = await widget.service.getGuestLecturerDetail(item.id);
    if (detail == null || !mounted) return;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  detail.fullName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Department: ${detail.departmentCode}'),
                Text('Degree: ${detail.academicDegree}'),
                Text('Position: ${detail.position}'),
                Text('Subject: ${detail.mainSubject}'),
                Text('Phone: ${detail.phone}'),
                Text('Teaching status: ${detail.teachingStatus}'),
                Text('Approval status: ${detail.approvalStatus}'),
                if (detail.contractSummary != null &&
                    detail.contractSummary!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Contract summary: ${detail.contractSummary}'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search guest lecturer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _load,
                child: const Text('Search'),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: AppAsyncView(
              isLoading: _isLoading,
              error: _error,
              onRetry: _load,
              empty: _items.isEmpty,
              emptyMessage: 'No guest lecturers found.',
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.fullName),
                      subtitle: Text(
                        '${item.departmentCode} | ${item.academicDegree} | ${item.mainSubject}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetail(item),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8),
                itemCount: _items.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
