import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoices_provider.dart';

class InvoicesListNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  InvoicesListNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchInvoices();
  }

  final StateNotifierProviderRef<InvoicesListNotifier,
      AsyncValue<List<Invoice>>> _ref;
  final List<Invoice> _invoices = [];
  String? _endCursor;

  Future<void> _fetchInvoices() async {
    try {
      final queryParams = InvoicesQueryParams(
        first: 10,
        after: _endCursor,
        sortBy: SortByEnum.dueDateDesc,
        sortDirection: SortDirectionEnum.desc,
      );

      final fetchedInvoices = _ref.read(invoicesQueryProvider(queryParams));

      fetchedInvoices.when(
        data: (invoices) {
          _invoices.addAll(invoices);
          _endCursor = invoices.last.dueDate.millisecondsSinceEpoch.toString();
        },
        loading: () {},
        error: (_, __) {},
      );

      state = AsyncValue.data(_invoices);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  void loadMoreInvoices() {
    _fetchInvoices();
  }
}

final invoicesListProvider =
    StateNotifierProvider<InvoicesListNotifier, AsyncValue<List<Invoice>>>(
        (ref) {
  return InvoicesListNotifier(ref);
});
