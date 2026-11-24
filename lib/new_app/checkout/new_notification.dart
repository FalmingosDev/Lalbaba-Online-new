
import 'package:flutter/material.dart';

import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';

// =============================================================
// NOTIFICATION MODEL
// =============================================================

enum NotificationType {
  order,
  delivery,
  offer,
  payment,
  general,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    this.isRead = false,
  });
}

// =============================================================
// NOTIFICATION PAGE
// =============================================================

class NewNotificationPage extends StatefulWidget {
  const NewNotificationPage({super.key});

  @override
  State<NewNotificationPage> createState() =>
      _NewNotificationPageState();
}

class _NewNotificationPageState
    extends State<NewNotificationPage> {

  // 0 = All, 1 = Unread
  int _selectedFilter = 0;

  // ===========================================================
  // SAMPLE NOTIFICATIONS
  // Replace with API notifications later.
  // ===========================================================

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Order Confirmed!',
      message:
          'Your order has been placed successfully. '
          'Thank you for shopping with Lalbaba Online.',
      createdAt: DateTime.now().subtract(
        const Duration(minutes: 25),
      ),
      type: NotificationType.order,
    ),

    AppNotification(
      id: '2',
      title: 'Your Order is On the Way',
      message:
          'Good news! Your rice products are '
          'out for delivery.',
      createdAt: DateTime.now().subtract(
        const Duration(hours: 2),
      ),
      type: NotificationType.delivery,
    ),

    AppNotification(
      id: '3',
      title: 'Special Offer Just for You!',
      message:
          'Discover exciting offers on our '
          'premium rice collection.',
      createdAt: DateTime.now().subtract(
        const Duration(hours: 5),
      ),
      type: NotificationType.offer,
    ),

    AppNotification(
      id: '4',
      title: 'Payment Successful',
      message:
          'Your payment has been received '
          'successfully.',
      createdAt: DateTime.now().subtract(
        const Duration(days: 1),
      ),
      type: NotificationType.payment,
      isRead: true,
    ),

    AppNotification(
      id: '5',
      title: 'Welcome to Lalbaba Online!',
      message:
          'Explore our products and enjoy '
          'a convenient shopping experience.',
      createdAt: DateTime.now().subtract(
        const Duration(days: 3),
      ),
      type: NotificationType.general,
      isRead: true,
    ),
  ];

  // ===========================================================
  // COUNTS
  // ===========================================================

  int get _unreadCount {
    return _notifications.where((n) => !n.isRead).length;
  }

  List<AppNotification> get _filteredNotifications {
    if (_selectedFilter == 1) {
      return _notifications.where((n) => !n.isRead).toList();
    }

    return List<AppNotification>.from(_notifications);
  }

  // ===========================================================
  // MARK AS READ
  // ===========================================================

  void _markAsRead(AppNotification notification) {
    if (notification.isRead) return;

    setState(() {
      notification.isRead = true;
    });
  }

  // ===========================================================
  // MARK ALL AS READ
  // ===========================================================

  void _markAllAsRead() {
    if (_unreadCount == 0) return;

    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ===========================================================
  // REMOVE NOTIFICATION
  // ===========================================================

  void _removeNotification(AppNotification notification) {
    setState(() {
      _notifications.removeWhere(
        (item) => item.id == notification.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification removed'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ===========================================================
  // DATE HELPERS
  // ===========================================================

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24 && _isToday(date)) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  // ===========================================================
  // NOTIFICATION ICON
  // ===========================================================

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.inventory_2_outlined;

      case NotificationType.delivery:
        return Icons.local_shipping_outlined;

      case NotificationType.offer:
        return Icons.local_offer_outlined;

      case NotificationType.payment:
        return Icons.account_balance_wallet_outlined;

      case NotificationType.general:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFF27834A);

      case NotificationType.delivery:
        return const Color(0xFF1976D2);

      case NotificationType.offer:
        return const Color(0xFFE89B22);

      case NotificationType.payment:
        return const Color(0xFF7B55C7);

      case NotificationType.general:
        return const Color(0xFF27834A);
    }
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;

    final todayNotifications = notifications
        .where((item) => _isToday(item.createdAt))
        .toList();

    final earlierNotifications = notifications
        .where((item) => !_isToday(item.createdAt))
        .toList();

    return Scaffold(
      backgroundColor: HomeColors.background,

      appBar: CommonAppBar(
        title: 'Notifications',
        height: 54,
        centerTitle: true,
        showBackButton: true,
        automaticallyImplyLeading: false,
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
        actions: [
          if (_unreadCount > 0)
            Tooltip(
              message: 'Mark all as read',
              child: IconButton(
                onPressed: _markAllAsRead,
                icon: const Icon(
                  Icons.done_all_rounded,
                  size: 24,
                  color: HomeColors.white,
                ),
              ),
            ),

          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ================================================
            // HEADER BANNER
            // ================================================

            _buildHeaderBanner(),

            // ================================================
            // NOTIFICATION SUMMARY
            // ================================================

            _buildNotificationSummary(),

            // ================================================
            // FILTER TABS
            // ================================================

            _buildFilterTabs(),

            // ================================================
            // NOTIFICATION LIST
            // ================================================

            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      physics:
                          const BouncingScrollPhysics(),

                      padding: const EdgeInsets.fromLTRB(
                        16,
                        10,
                        16,
                        30,
                      ),

                      children: [
                        if (todayNotifications.isNotEmpty) ...[
                          _buildSectionTitle('Today'),

                          const SizedBox(height: 10),

                          ...todayNotifications.map(
                            (notification) =>
                                _buildNotificationCard(
                              notification,
                            ),
                          ),
                        ],

                        if (earlierNotifications.isNotEmpty) ...[
                          const SizedBox(height: 14),

                          _buildSectionTitle('Earlier'),

                          const SizedBox(height: 10),

                          ...earlierNotifications.map(
                            (notification) =>
                                _buildNotificationCard(
                              notification,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER BANNER
  // ===========================================================

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            HomeColors.secondary,
            Color(0xFF379F59),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: HomeColors.secondary.withValues(
              alpha: 0.14,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.notifications_active_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Updated!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Your orders, offers & updates '
                  'in one place.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // NOTIFICATION SUMMARY
  // ===========================================================

  Widget _buildNotificationSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 8,
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Notifications',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: HomeColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _unreadCount == 0
                      ? 'You are all caught up!'
                      : '$_unreadCount unread notifications',

                  style: const TextStyle(
                    fontSize: 12,
                    color: HomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (_unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),

              decoration: BoxDecoration(
                color: HomeColors.secondary.withValues(
                  alpha: 0.10,
                ),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                '$_unreadCount New',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================
  // FILTER TABS
  // ===========================================================

  Widget _buildFilterTabs() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        10,
      ),

      child: Row(
        children: [
          _buildFilterChip(
            label: 'All (${_notifications.length})',
            index: 0,
          ),

          const SizedBox(width: 10),

          _buildFilterChip(
            label: 'Unread ($_unreadCount)',
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedFilter == index;

    return Material(
      color: isSelected
          ? HomeColors.secondary
          : HomeColors.white,

      borderRadius: BorderRadius.circular(30),

      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },

        borderRadius: BorderRadius.circular(30),

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            border: Border.all(
              color: isSelected
                  ? HomeColors.secondary
                  : HomeColors.border,
            ),
          ),

          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,

              color: isSelected
                  ? Colors.white
                  : HomeColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // SECTION TITLE
  // ===========================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 2,
      ),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: HomeColors.textPrimary,
        ),
      ),
    );
  }

  // ===========================================================
  // NOTIFICATION CARD
  // ===========================================================

  Widget _buildNotificationCard(
    AppNotification notification,
  ) {
    final bool unread = !notification.isRead;

    final Color iconColor =
        _getNotificationColor(notification.type);

    return Padding(
      key: ValueKey(notification.id),
      padding: const EdgeInsets.only(bottom: 10),

      child: Dismissible(
        key: ValueKey('dismiss-${notification.id}'),

        direction: DismissDirection.endToStart,

        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),

          decoration: BoxDecoration(
            color: HomeColors.error,
            borderRadius: BorderRadius.circular(15),
          ),

          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),

        onDismissed: (_) {
          _removeNotification(notification);
        },

        child: Material(
          color: unread
              ? const Color(0xFFF1FAF3)
              : HomeColors.white,

          borderRadius: BorderRadius.circular(15),

          child: InkWell(
            onTap: () {
              _markAsRead(notification);
            },

            borderRadius: BorderRadius.circular(15),

            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),

                border: Border.all(
                  color: unread
                      ? HomeColors.secondary.withValues(
                          alpha: 0.20,
                        )
                      : HomeColors.border,
                ),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // NOTIFICATION TYPE ICON

                  Container(
                    width: 44,
                    height: 44,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: iconColor.withValues(
                        alpha: 0.11,
                      ),

                      borderRadius:
                          BorderRadius.circular(13),
                    ),

                    child: Icon(
                      _getNotificationIcon(
                        notification.type,
                      ),

                      color: iconColor,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // NOTIFICATION CONTENT

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Expanded(
                              child: Text(
                                notification.title,

                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: unread
                                      ? FontWeight.w700
                                      : FontWeight.w600,

                                  color: HomeColors.textPrimary,
                                ),
                              ),
                            ),

                            if (unread) ...[
                              const SizedBox(width: 6),

                              Container(
                                width: 8,
                                height: 8,

                                margin:
                                    const EdgeInsets.only(
                                  top: 5,
                                ),

                                decoration:
                                    const BoxDecoration(
                                  color: HomeColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          notification.message,

                          style: const TextStyle(
                            fontSize: 12,
                            color: HomeColors.textSecondary,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: HomeColors.textSecondary,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              _formatTime(
                                notification.createdAt,
                              ),

                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: HomeColors.textSecondary,
                              ),
                            ),

                            const Spacer(),

                            if (unread)
                              const Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: HomeColors.secondary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    final bool showingUnread = _selectedFilter == 1;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color: HomeColors.secondary.withValues(
                  alpha: 0.08,
                ),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.notifications_off_outlined,
                size: 48,
                color: HomeColors.secondary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              showingUnread
                  ? 'No Unread Notifications'
                  : 'No Notifications Yet',

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HomeColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              showingUnread
                  ? 'You have read all your notifications.'
                  : 'Your order updates and offers '
                      'will appear here.',

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: HomeColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            if (showingUnread)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 0;
                  });
                },

                child: const Text(
                  'View All Notifications',

                  style: TextStyle(
                    color: HomeColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
