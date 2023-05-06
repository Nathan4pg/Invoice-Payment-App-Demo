import 'package:flutter_invoice_app/repository/invoices_repository.dart';

abstract class InvoicesEvent {}

class LoadInvoices extends InvoicesEvent {
  final InvoicesQueryParams queryParams;

  LoadInvoices({required this.queryParams}) {
    print('LoadInvoices event called with queryParams:');
    print('  first: ${queryParams.first}');
    print('  sortBy: ${queryParams.sortBy}');
    print('  sortDirection: ${queryParams.sortDirection}');
  }
}

class ToggleInvoiceSelection extends InvoicesEvent {
  final String invoiceId;

  ToggleInvoiceSelection({required this.invoiceId}) {
    print('ToggleInvoiceSelection event called with invoiceId: $invoiceId');
  }
}
