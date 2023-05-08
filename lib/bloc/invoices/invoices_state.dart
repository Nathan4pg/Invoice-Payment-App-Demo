import 'package:equatable/equatable.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';

abstract class InvoicesState extends Equatable {
  const InvoicesState();

  factory InvoicesState.fromJson(Map<String, dynamic> json) {
    if (json['runtimeType'] == 'InvoicesLoaded') {
      return InvoicesLoaded.fromJson(json);
    }
    // Add other state types if needed
    return const InvoicesInitial();
  }

  Map<String, dynamic> toJson();

  @override
  List<Object> get props => [];
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();

  @override
  Map<String, dynamic> toJson() {
    return {'runtimeType': 'InvoicesInitial'};
  }
}

class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();

  @override
  Map<String, dynamic> toJson() {
    return {'runtimeType': 'InvoicesLoading'};
  }
}

class InvoicesLoaded extends InvoicesState {
  final List<Invoice> invoices;
  final Set<String> selectedInvoices;

  const InvoicesLoaded({
    required this.invoices,
    this.selectedInvoices = const {},
  });

  factory InvoicesLoaded.fromJson(Map<String, dynamic> json) {
    return InvoicesLoaded(
      invoices: (json['invoices'] as List)
          .map((invoiceJson) => Invoice.fromJson(invoiceJson))
          .toList(),
      selectedInvoices: Set<String>.from(json['selectedInvoices']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'runtimeType': 'InvoicesLoaded',
      'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
      'selectedInvoices': selectedInvoices.toList(),
    };
  }

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

  const InvoicesError({required this.message});

  @override
  Map<String, dynamic> toJson() {
    return {'runtimeType': 'InvoicesError', 'message': message};
  }

  @override
  List<Object> get props => [message];
}

class InvoicesSelectionChanged extends InvoicesState {
  final Set<String> selectedInvoices;

  const InvoicesSelectionChanged(this.selectedInvoices);

  @override
  Map<String, dynamic> toJson() {
    return {
      'runtimeType': 'InvoicesSelectionChanged',
      'selectedInvoices': selectedInvoices.toList(),
    };
  }

  @override
  List<Object> get props => [selectedInvoices];
}
