import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/widgets/details_button.dart';
import 'package:flutter_invoice_app/constants/enums.dart';

class InvoicesListScreen extends StatelessWidget {
  const InvoicesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryParams = InvoicesQueryParams(
      first: 10,
      sortBy: SortByEnum.dueDateDesc,
      sortDirection: SortDirectionEnum.desc,
    );

    context
        .read<InvoicesBloc>()
        .add(LoadInvoices(queryParams: queryParams)); // Add this line

    return Scaffold(
        appBar: AppBar(title: const Text('Invoices')),
        body: BlocBuilder<InvoicesBloc, InvoicesState>(
          builder: (BuildContext context, InvoicesState state) {
            if (state is InvoicesLoaded) {
              final selectedInvoices = state.selectedInvoices;

              return ListView.builder(
                itemCount: state.invoices.length,
                itemBuilder: (BuildContext context, int index) {
                  final invoice = state.invoices[index];
                  final isSelected = selectedInvoices.contains(invoice.id);

                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value != null) {
                          context.read<InvoicesBloc>().add(
                                ToggleInvoiceSelection(invoiceId: invoice.id),
                              );
                        }
                      },
                    ),
                    title: Text(invoice.orderNumber),
                    trailing: DetailsButton(invoice: invoice),
                    onTap: () {
                      context.read<InvoicesBloc>().add(
                            ToggleInvoiceSelection(invoiceId: invoice.id),
                          );
                    },
                  );
                },
              );
            } else if (state is InvoicesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoicesError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              context
                  .read<InvoicesBloc>()
                  .add(LoadInvoices(queryParams: queryParams));
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
