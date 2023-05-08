import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/widgets/details_button.dart';
import 'package:flutter_invoice_app/constants/enums.dart'; // Import the enums.dart file

// class InvoicesQueryParams {
//   final int first;
//   final SortByEnum sortBy;
//   final SortDirectionEnum sortDirection;

//   InvoicesQueryParams({
//     required this.first,
//     required this.sortBy,
//     required this.sortDirection,
//   });
// }

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
            print('Contest: $context');
            print('Current state: $state');

            if (state is InvoicesLoaded) {
              final selectedInvoices = state.selectedInvoices;

              print('Invoices loaded: ${state.invoices}');
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
              print('Invoices loading...');
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoicesError) {
              print('Error loading invoices: ${state.message}');
              return Center(child: Text('Error: ${state.message}'));
            } else {
              print('Unknown state: $state');
              context
                  .read<InvoicesBloc>()
                  .add(LoadInvoices(queryParams: queryParams));
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
