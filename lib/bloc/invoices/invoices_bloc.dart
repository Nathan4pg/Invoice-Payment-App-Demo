import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:flutter_invoice_app/repository/invoices_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final InvoicesRepository _invoicesRepository;

  InvoicesBloc({required GraphQLClient client})
      : _invoicesRepository = InvoicesRepository(client: client),
        super(const InvoicesInitial()) {
    on<LoadInvoices>((event, emit) async {
      _mapLoadInvoicesToState(event, emit);
    });
    on<ToggleInvoiceSelection>((event, emit) async {
      _mapToggleInvoiceSelectionToState(event, emit);
    });
  }

  Stream<InvoicesState> _mapLoadInvoicesToState(
    LoadInvoices event,
    Emitter<InvoicesState> emit,
  ) async* {
    emit(const InvoicesLoading());
    try {
      final List<Invoice> invoices =
          await _invoicesRepository.fetchInvoicesWithParams(event.queryParams);
      emit(InvoicesLoaded(
        invoices: invoices,
        selectedInvoices: const {},
      ));
    } catch (e) {
      print('Failed to load invoices: $e');
      emit(const InvoicesError(message: 'Failed to load invoices'));
    }
  }

  Stream<InvoicesState> _mapToggleInvoiceSelectionToState(
      ToggleInvoiceSelection event, Emitter<InvoicesState> emit) async* {
    if (state is InvoicesLoaded) {
      final selectedInvoices = Set<String>.from(
        (state as InvoicesLoaded).selectedInvoices,
      );
      if (selectedInvoices.contains(event.invoiceId)) {
        selectedInvoices.remove(event.invoiceId);
      } else {
        selectedInvoices.add(event.invoiceId);
      }
      emit(InvoicesLoaded(
        invoices: (state as InvoicesLoaded).invoices,
        selectedInvoices: selectedInvoices,
      ));
    }
  }
}
