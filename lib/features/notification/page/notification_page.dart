import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // ---------------- Colors ----------------
  static const Color bgColor = Colors.white;
  static const Color titleColor = Color(0xFF1F1B2E);
  static const Color redColor = Color(0xFFE53935);
  static const Color timeColor = Color(0xFF9E9E9E);
  static const Color dividerColor = Color(0xFFE8E8E8);

  // ---------------- Dummy Data ----------------
  final List<OrderNotificationItem> notifications = const [
    OrderNotificationItem(
      orderId: 'LB23090523133267',
      status: 'has been Confirmed',
      time: 'September 5 2023, 11:13 pm',
    ),
    OrderNotificationItem(
      orderId: 'LB23090523133267',
      status: 'has been Placed',
      time: 'September 5 2023, 11:13 pm',
    ),
    OrderNotificationItem(
      orderId: 'LB23042912374591',
      status: 'has been Delivered',
      time: 'May 2 2023, 8:30 pm',
    ),
    OrderNotificationItem(
      orderId: 'LB23042912374591',
      status: 'has been Out for delivery',
      time: 'May 2 2023, 1:30 pm',
    ),
    OrderNotificationItem(
      orderId: 'LB23042912374591',
      status: 'has been On the way',
      time: 'May 1 2023, 8:30 pm',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: bgColor,
        foregroundColor: titleColor,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: dividerColor,
          ),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: timeColor, fontSize: 14),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: dividerColor,
              ),
              itemBuilder: (context, index) {
                return _buildNotificationTile(notifications[index]);
              },
            ),
    );
  }

  // ---------------- Single Tile ----------------
  Widget _buildNotificationTile(OrderNotificationItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 17,
                color: titleColor,
                height: 1.35,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'Your Order: '),
                TextSpan(
                  text: item.orderId,
                  style: const TextStyle(
                    color: redColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' ${item.status}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.time,
            style: const TextStyle(
              fontSize: 14,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Model ----------------
class OrderNotificationItem {
  final String orderId;
  final String status;
  final String time;

  const OrderNotificationItem({
    required this.orderId,
    required this.status,
    required this.time,
  });
}