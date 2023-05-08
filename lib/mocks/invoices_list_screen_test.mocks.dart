import 'dart:async';

import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:bloc/bloc.dart';

class MockInvoicesBloc extends Mock implements InvoicesBloc {
  @override
  Stream<InvoicesState> get stream => streamController.stream;
  final streamController = StreamController<InvoicesState>.broadcast();

  bool _addCalled = false;
  InvoicesEvent? _addCalledWith;

  @override
  void add(InvoicesEvent event) {
    _addCalled = true;
    _addCalledWith = event;
  }

  bool get addCalled => _addCalled;
  InvoicesEvent? get addCalledWith => _addCalledWith;

  @override
  Future<void> close() async {
    await streamController.close();
  }

  @override
  void onEvent(InvoicesEvent event) {}

  @override
  void onTransition(Transition<InvoicesEvent, InvoicesState> transition) {}

  @override
  void onError(Object error, StackTrace stackTrace) {}
}
