import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoices_provider.dart';
import '../widgets/details_button.dart';
import '../models/selected_invoices_provider.dart';

class InvoicesList extends ConsumerWidget {
  const InvoicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsyncValue =
        ref.watch(invoicesQueryProvider(InvoicesQueryParams()));
    final selectedInvoices = ref.watch(selectedInvoicesProvider);

    return invoicesAsyncValue.when(
      data: (invoices) => DataTable(
        columns: const [
          DataColumn(label: Text('Select')),
          DataColumn(label: Text('Due Date')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Details')),
        ],
        rows: invoices.map((invoice) {
          bool isPaid = invoice.paid;
          bool isSelected = selectedInvoices.contains(invoice.id);

          return DataRow(
            selected: isSelected,
            onSelectChanged: isPaid
                ? null
                : (bool? value) {
                    if (value != null && value) {
                      ref
                          .read(selectedInvoicesProvider.notifier)
                          .add(invoice.id);
                    } else {
                      ref
                          .read(selectedInvoicesProvider.notifier)
                          .remove(invoice.id);
                    }
                  },
            cells: [
              DataCell(Checkbox(value: isSelected, onChanged: null)),
              DataCell(Text(invoice.dueDate.toString())),
              DataCell(Text(invoice.amount)),
              DataCell(DetailsButton(invoice: invoice)),
            ],
          );
        }).toList(),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
