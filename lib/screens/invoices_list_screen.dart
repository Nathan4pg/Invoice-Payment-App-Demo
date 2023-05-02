import 'package:flutter/material.dart';
import 'package:flutter_invoice_app/providers/invoices_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/invoices_list.dart';

class InvoicesListScreen extends ConsumerWidget {
  const InvoicesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryParams = InvoicesQueryParams(
      first: 10,
      sortBy: SortByEnum.dueDateDesc,
      sortDirection: SortDirectionEnum.desc,
    );

    return Column(
      children: [
        const Text('Check for update'),
        ref.read(invoicesProvider(queryParams)).when(
              data: (_) => const InvoicesList(),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
            ),
      ],
    );
  }
}
