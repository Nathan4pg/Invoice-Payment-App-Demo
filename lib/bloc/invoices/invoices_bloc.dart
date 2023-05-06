import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:flutter_invoice_app/repository/invoices_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'invoices_event.dart';
import 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final InvoicesRepository _invoicesRepository;
  final Set<String> _selectedInvoices = {};

  InvoicesBloc({required GraphQLClient client})
      : _invoicesRepository = InvoicesRepository(client),
        super(const InvoicesInitial()) {
    on<LoadInvoices>((event, emit) => _mapLoadInvoicesToState(event, emit));
    on<ToggleInvoiceSelection>(
        (event, emit) => _mapToggleInvoiceSelectionToState(event, emit));
  }

  Stream<InvoicesState> _mapToggleInvoiceSelectionToState(
      ToggleInvoiceSelection event, Emitter<InvoicesState> emit) async* {
    print('ToggleInvoiceSelection Event received');
    if (_selectedInvoices.contains(event.invoiceId)) {
      _selectedInvoices.remove(event.invoiceId);
    } else {
      _selectedInvoices.add(event.invoiceId);
    }
    final currentState = state;
    if (currentState is InvoicesLoaded) {
      emit(currentState.copyWith(selectedInvoices: _selectedInvoices));
      print(
          'ToggleInvoiceSelection State emitted: ${currentState.copyWith(selectedInvoices: _selectedInvoices)}');
    }
  }

  Stream<InvoicesState> _mapLoadInvoicesToState(
      LoadInvoices event, Emitter<InvoicesState> emit) async* {
    print('LoadInvoices Event received');
    try {
      print('Loading invoices...');
      emit(const InvoicesLoading());
      print('InvoicesLoading State emitted');

      final List<Invoice> invoices =
          await _invoicesRepository.fetchInvoices(event.queryParams);
      print('Fetched invoices: $invoices');
      emit(InvoicesLoaded(invoices: invoices));
      print(
          'InvoicesLoaded State emitted: ${InvoicesLoaded(invoices: invoices)}');
    } catch (e) {
      print('Error: $e');
      emit(InvoicesError(e.toString()));
      print('InvoicesError State emitted: ${InvoicesError(e.toString())}');
    }
  }
}
