import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_config.dart';
import '../services/auth_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreNotifications();
      }
    }
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final user = await AuthService().getCurrentUser();
      final userId = user != null ? user['id'] : null;
      print('Current user ID: $userId');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications?page=1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> loaded = List<Map<String, dynamic>>.from(
          data['data'],
        );
        if (userId != null &&
            loaded.isNotEmpty &&
            loaded.first.containsKey('notifiable_id')) {
          loaded = loaded.where((n) => n['notifiable_id'] == userId).toList();
        }
        setState(() {
          _notifications = loaded;
          _currentPage = 1;
          _hasMore = data['meta']['current_page'] < data['meta']['last_page'];
          _isLoading = false;
        });
        print('Loaded notifications:');
        for (final n in _notifications) {
          print(n);
        }
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_loading_notifications'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final nextPage = _currentPage + 1;
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications?page=$nextPage'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _notifications.addAll(List<Map<String, dynamic>>.from(data['data']));
          _currentPage = nextPage;
          _hasMore = data['meta']['current_page'] < data['meta']['last_page'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load more notifications');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final token = await AuthService().getToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = _notifications.indexWhere(
            (n) => n['id'] == notificationId,
          );
          if (index != -1) {
            _notifications[index]['read_at'] = DateTime.now().toIso8601String();
          }
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final token = await AuthService().getToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/mark-all-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          for (var notification in _notifications) {
            notification['read_at'] = DateTime.now().toIso8601String();
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('all_notifications_marked_read'.tr()),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_marking_read'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('clear_all_notifications'.tr()),
            content: Text('clear_all_notifications_confirm'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('clear'.tr()),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    try {
      final token = await AuthService().getToken();
      if (token == null) return;

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications.clear();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('all_notifications_cleared'.tr()),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_clearing_notifications'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['read_at'] != null;
    final type = notification['type'] ?? '';
    final data = notification['data'] ?? {};
    final title =
        ((data['title'] ?? notification['title'] ?? '')
                .toString()
                .trim()
                .isNotEmpty)
            ? (data['title'] ?? notification['title'])
            : 'Notification';
    final message =
        ((data['message'] ?? notification['message'] ?? '')
                .toString()
                .trim()
                .isNotEmpty)
            ? (data['message'] ?? notification['message'])
            : 'You have a new notification.';
    final createdAt = DateTime.tryParse(notification['created_at'] ?? '');
    final isFeedbackResponse = type == 'feedback_response';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isRead ? 1 : 3,
      color: isRead ? Colors.grey[50] : Colors.white,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                isFeedbackResponse
                    ? const Color(0xFF4CAF50).withAlpha((0.1 * 255).toInt())
                    : Colors.blue.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            isFeedbackResponse ? Icons.feedback : Icons.notifications,
            color: isFeedbackResponse ? const Color(0xFF4CAF50) : Colors.blue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
            color: isRead ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isRead ? Colors.grey[600] : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            if (createdAt != null)
              Text(
                _formatDate(createdAt),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
          ],
        ),
        onTap: () {
          if (!isRead) {
            _markAsRead(notification['id']);
          }
          // Show notification details
          _showNotificationDetails(notification);
        },
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    final type = notification['type'] ?? '';
    final isFeedbackResponse = type == 'feedback_response';
    final data = notification['data'] ?? {};
    final title =
        ((data['title'] ?? notification['title'] ?? '')
                .toString()
                .trim()
                .isNotEmpty)
            ? (data['title'] ?? notification['title'])
            : 'Notification';
    final message =
        ((data['message'] ?? notification['message'] ?? '')
                .toString()
                .trim()
                .isNotEmpty)
            ? (data['message'] ?? notification['message'])
            : 'You have a new notification.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isFeedbackResponse
                                ? const Color(
                                  0xFF4CAF50,
                                ).withAlpha((0.1 * 255).toInt())
                                : Colors.blue.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isFeedbackResponse
                            ? Icons.feedback
                            : Icons.notifications,
                        color:
                            isFeedbackResponse
                                ? const Color(0xFF4CAF50)
                                : Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatDate(
                              DateTime.tryParse(
                                notification['created_at'] ?? '',
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(message, style: const TextStyle(fontSize: 16)),
                if (isFeedbackResponse) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'your_feedback'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification['feedback_message'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'our_response'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF4CAF50,
                      ).withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification['response'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF4CAF50), width: 4.0)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'notifications'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _loadNotifications,
                      icon: const Icon(Icons.refresh, color: Color(0xFF4CAF50)),
                    ),
                    if (_notifications.isNotEmpty)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'mark_all_read':
                              _markAllAsRead();
                              break;
                            case 'clear_all':
                              _clearAllNotifications();
                              break;
                          }
                        },
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'mark_all_read',
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 16),
                                    const SizedBox(width: 8),
                                    Text('mark_all_read'.tr()),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'clear_all',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.clear_all,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text('clear_all'.tr()),
                                  ],
                                ),
                              ),
                            ],
                        child: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child:
                    _notifications.isEmpty && !_isLoading
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_notifications'.tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'no_notifications_desc'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: _loadNotifications,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                _notifications.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _notifications.length) {
                                return _hasMore
                                    ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    : const SizedBox.shrink();
                              }
                              return _buildNotificationItem(
                                _notifications[index],
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
