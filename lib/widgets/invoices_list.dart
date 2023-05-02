import 'package:flutter/material.dart';
import 'package:flutter_invoice_app/providers/invoices_provider.dart'; // Make sure this import is correct
import 'package:flutter_invoice_app/providers/selected_invoices_provider.dart';
import '../widgets/details_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoicesList extends ConsumerWidget {
  const InvoicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInvoices = ref.read(selectedInvoicesProvider);
    final invoicesAsyncValue =
        ref.watch(invoicesProvider(InvoicesQueryParams())); // Updated this line

    return invoicesAsyncValue.when(
      data: (invoices) {
        return ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (BuildContext context, int index) {
            final invoice = invoices[index];
            final isSelected = selectedInvoices.contains(invoice.id);

            return ListTile(
              leading: Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  if (value != null) {
                    ref
                        .read(selectedInvoicesProvider.notifier)
                        .toggleInvoiceSelection(invoice.id, value);
                  }
                },
              ),
              title: Text(invoice.orderNumber),
              trailing: DetailsButton(invoice: invoice),
              onTap: () {
                ref
                    .read(selectedInvoicesProvider.notifier)
                    .toggleInvoiceSelection(invoice.id, !isSelected);
              },
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
