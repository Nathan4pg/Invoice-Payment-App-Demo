import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:flutter_invoice_app/constants/enums.dart';
import 'package:intl/intl.dart';

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({Key? key}) : super(key: key);

  @override
  InvoicesListScreenState createState() => InvoicesListScreenState();
}

class InvoicesListScreenState extends State<InvoicesListScreen> {
  @override
  Widget build(BuildContext context) {
    final queryParams = InvoicesQueryParams(
      first: 10,
      sortBy: SortByEnum.dueDateDesc,
      sortDirection: SortDirectionEnum.desc,
    );

    context.read<InvoicesBloc>().add(LoadInvoices(queryParams: queryParams));

    return BlocBuilder<InvoicesBloc, InvoicesState>(
      builder: (BuildContext context, InvoicesState state) {
        if (state is InvoicesLoaded) {
          final selectedInvoices = state.selectedInvoices;

          return ListView(
            children: [
              ExpansionPanelList.radio(
                  children: state.invoices
                      .map<ExpansionPanelRadio>((Invoice invoice) {
                return ExpansionPanelRadio(
                  value: invoice.id,
                  headerBuilder: (BuildContext context, bool isExpanded) {
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
                      subtitle: Text(
                          'Due: ${DateFormat.yMMMd().format(invoice.dueDate)}'),
                      title: Text(invoice.grossAmount),
                    );
                  },
                  body: Column(
                    children: [
                      ListTile(
                        title: const Text('Tracking ID:'),
                        subtitle: Text(invoice.shipmentTrackingId),
                        trailing: const Icon(Icons.local_shipping),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Sales Rep:'),
                        subtitle: Text(invoice.salesRepresentative),
                        trailing: const Icon(Icons.contact_mail),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('Order #:'),
                        subtitle: Text(invoice.orderNumber),
                        trailing: const Icon(Icons.info),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              }).toList()),
            ],
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
    );
  }
}
