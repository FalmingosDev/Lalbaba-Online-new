import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

/// Status of a support ticket.
///
/// NOTE: Every new ticket is created as [TicketStatus.pending] for now.
/// Once the backend API is wired up, statuses will come straight from
/// there (see `TicketRepository`).
enum TicketStatus {
  pending,
  inProgress,
  resolved,
  closed;

  static TicketStatus fromApi(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return TicketStatus.pending;
      case 'in_progress':
      case 'inprogress':
        return TicketStatus.inProgress;
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.pending;
    }
  }
}

extension TicketStatusX on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.pending:
        return AppColors.warning;
      case TicketStatus.inProgress:
        return AppColors.info;
      case TicketStatus.resolved:
        return AppColors.success;
      case TicketStatus.closed:
        return AppColors.textSecondary;
    }
  }
}

/// Model for a single support ticket.
@immutable
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
    this.photoPaths = const [],
  });

  final String id;
  final String subject;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;

  /// Local file paths before upload, or remote URLs once the API
  /// integration is wired up.
  final List<String> photoPaths;

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'].toString(),
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: TicketStatus.fromApi(json['status'] as String? ?? 'pending'),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      photoPaths: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'photos': photoPaths,
    };
  }
}
