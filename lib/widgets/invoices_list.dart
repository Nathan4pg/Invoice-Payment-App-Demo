import 'package:flutter/material.dart';
import '../widgets/details_button.dart';
import '../models/selected_invoices_provider.dart';
import '../models/invoices_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:provider/provider.dart';

class InvoicesList extends ConsumerStatefulWidget {
  const InvoicesList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InvoicesListState();
}

class InvoicesListState extends ConsumerState<InvoicesList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        ref.read(invoicesListProvider.notifier).loadMoreInvoices();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedInvoices = ref.read(selectedInvoicesProvider);
    final invoicesAsyncValue = ref.watch(invoicesListProvider);

    return invoicesAsyncValue.when(
      data: (invoices) => Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.grey,
        height: 400,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: invoices.length,
          itemBuilder: (BuildContext context, int index) {
            final invoice = invoices[index];
            bool isPaid = invoice.paid;
            bool isSelected = selectedInvoices.contains(invoice.id);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Select')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Details')),
                  ],
                  rows: [
                    DataRow(
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
