import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../presentation/widget/support_ticket.dart';
import '../presentation/widget/ticket_repository.dart';



/// Provides the repository implementation.
///
/// Override this in a real environment once the API repository exists,
/// e.g. `ticketRepositoryProvider.overrideWithValue(ApiTicketRepository())`.
final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return MockTicketRepository();
});

/// Holds the list of support tickets shown on the Contact Us page.
final ticketListProvider =
    AsyncNotifierProvider<TicketListController, List<SupportTicket>>(
  TicketListController.new,
);

class TicketListController extends AsyncNotifier<List<SupportTicket>> {
  TicketRepository get _repository => ref.read(ticketRepositoryProvider);

  @override
  FutureOr<List<SupportTicket>> build() {
    return _repository.getTickets();
  }

  /// Reloads the ticket list from the API.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTickets());
  }

  /// Creates a new ticket (status: Pending) and refreshes the list.
  Future<void> createTicket({
    required String subject,
    required String description,
    required List<XFile> photos,
  }) async {
    await _repository.createTicket(
      subject: subject,
      description: description,
      photos: photos,
    );

    state = await AsyncValue.guard(() => _repository.getTickets());
  }
}
