import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedInvoicesProvider =
    StateNotifierProvider<SelectedInvoices, Set<String>>(
        (ref) => SelectedInvoices());

class SelectedInvoices extends StateNotifier<Set<String>> {
  SelectedInvoices() : super(<String>{});

  void add(String invoiceId) {
    state.add(invoiceId);
    state = Set<String>.from(state);
  }

  void remove(String invoiceId) {
    state.remove(invoiceId);
    state = Set<String>.from(state);
  }

  // Added the toggleInvoiceSelection method to the SelectedInvoices class
  void toggleInvoiceSelection(String invoiceId, bool isSelected) {
    if (isSelected) {
      add(invoiceId);
    } else {
      remove(invoiceId);
    }
  }
}
