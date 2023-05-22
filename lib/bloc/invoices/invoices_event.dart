import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';

abstract class InvoicesEvent {}

class LoadInvoices extends InvoicesEvent {
  final InvoicesQueryParams queryParams;
  LoadInvoices({required this.queryParams});
}

class ToggleInvoiceSelection extends InvoicesEvent {
  final String invoiceId;
  ToggleInvoiceSelection({required this.invoiceId});
}
