import 'package:image_picker/image_picker.dart';


import 'support_ticket.dart';

/// Abstraction over the ticket data source.
///
/// Swap [MockTicketRepository] with a real HTTP implementation once the
/// backend API is ready — nothing else in this feature needs to change,
/// only the override on [ticketRepositoryProvider] in `ticket_providers.dart`.
abstract class TicketRepository {
  Future<List<SupportTicket>> getTickets();

  Future<SupportTicket> createTicket({
    required String subject,
    required String description,
    required List<XFile> photos,
  });
}

/// Temporary in-memory implementation used until the API is ready.
///
/// TODO(api): Replace with a real implementation, e.g.
///   GET  /support-tickets       -> getTickets
///   POST /support-tickets       -> createTicket (multipart, with photos)
class MockTicketRepository implements TicketRepository {
  final List<SupportTicket> _tickets = [];

  @override
  Future<List<SupportTicket>> getTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_tickets);
  }

  @override
  Future<SupportTicket> createTicket({
    required String subject,
    required String description,
    required List<XFile> photos,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final ticket = SupportTicket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      description: description,
      // Always Pending for now — the real status will come from the API.
      status: TicketStatus.pending,
      createdAt: DateTime.now(),
      photoPaths: photos.map((file) => file.path).toList(),
    );

    _tickets.insert(0, ticket);
    return ticket;
  }
}
