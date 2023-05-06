import 'package:equatable/equatable.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';

abstract class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object> get props => [];
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

class InvoicesLoaded extends InvoicesState {
  final List<Invoice> invoices;
  final Set<String> selectedInvoices;

  const InvoicesLoaded({
    required this.invoices,
    this.selectedInvoices = const {},
  });

  InvoicesLoaded copyWith({
    List<Invoice>? invoices,
    Set<String>? selectedInvoices,
  }) {
    return InvoicesLoaded(
      invoices: invoices ?? this.invoices,
      selectedInvoices: selectedInvoices ?? this.selectedInvoices,
    );
  }

  @override
  List<Object> get props => [invoices, selectedInvoices];
}

class InvoicesError extends InvoicesState {
  final String message;

  const InvoicesError(this.message);

  @override
  List<Object> get props => [message];
}

class InvoicesSelectionChanged extends InvoicesState {
  final Set<String> selectedInvoices;

  const InvoicesSelectionChanged(this.selectedInvoices);

  @override
  List<Object> get props => [selectedInvoices];
}
