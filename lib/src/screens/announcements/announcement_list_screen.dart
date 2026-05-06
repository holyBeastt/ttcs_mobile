import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/src/models/announcement.dart';
import 'package:mobile/src/models/session_user.dart';
import 'package:mobile/src/services/announcement_service.dart';
import 'package:mobile/src/widgets/app_async_view.dart';
import 'package:mobile/src/config/injector.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({
    super.key,
    required this.user,
  });

  final SessionUser user;

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  bool _isLoading = true;
  String? _error;
  List<Announcement> _announcements = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = await getIt<AnnouncementService>().getAnnouncements(widget.user.departmentCode);
      setState(() {
        _announcements = items;
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

  Future<void> _openDetail(Announcement item) async {
    final detail = await getIt<AnnouncementService>().getAnnouncementDetail(
      widget.user.departmentCode,
      item.id,
    );
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
                  detail.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Phòng ban: ${detail.departmentCode}'),
                Text('Hạn chót: ${_formatDate(detail.deadline)}'),
                Text('Hết hạn: ${detail.expired ? 'Có' : 'Không'}'),
                const SizedBox(height: 16),
                Text(detail.message),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: AppAsyncView(
        isLoading: _isLoading,
        error: _error,
        onRetry: _load,
        empty: _announcements.isEmpty,
        emptyMessage: 'Không tìm thấy thông báo nào.',
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = _announcements[index];
            return Card(
              child: ListTile(
                title: Text(item.title),
                subtitle: Text(
                  '${item.departmentCode} | ${_formatDate(item.deadline)}',
                ),
                trailing: item.expired
                    ? const Icon(Icons.schedule, color: Colors.orange)
                    : const Icon(Icons.chevron_right),
                onTap: () => _openDetail(item),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: _announcements.length,
        ),
      ),
    );
  }
}
