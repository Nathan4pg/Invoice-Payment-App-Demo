import 'dart:async';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_invoice_app/constants/enums.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class EnumConverters {
  static String sortByEnumToString(SortByEnum value) {
    switch (value) {
      case SortByEnum.dueDateAsc:
        return 'DUE_DATE_ASC';
      case SortByEnum.dueDateDesc:
        return 'DUE_DATE_DESC';
      default:
        throw ArgumentError('Unknown SortByEnum: $value');
    }
  }

  static String sortDirectionEnumToString(SortDirectionEnum value) {
    switch (value) {
      case SortDirectionEnum.asc:
        return 'ASC';
      case SortDirectionEnum.desc:
        return 'DESC';
      default:
        throw ArgumentError('Unknown SortDirectionEnum: $value');
    }
  }
}

const String fetchInvoices = r'''
  query FetchInvoices($first: Int, $sortBy: SortByEnum, $sortDirection: SortDirectionEnum) {
    invoices(first: $first, sortBy: $sortBy, sortDirection: $sortDirection) {
      edges {
        node {
          id
          amount
          paid
          dueDate
          paidDate
          grossAmount
          invoicedDate
          orderNumber
          deliveryDate
          salesRepresentative
          shippingCompany
          shipmentTrackingId
        }
      }
    }
  }
''';

class InvoicesQueryParams {
  final int first;
  final SortByEnum sortBy;
  final SortDirectionEnum sortDirection;

  InvoicesQueryParams({
    required this.first,
    required this.sortBy,
    required this.sortDirection,
  });

  Map<String, dynamic> toMap() {
    return {
      'first': first,
      'sortBy': EnumConverters.sortByEnumToString(sortBy),
      'sortDirection': EnumConverters.sortDirectionEnumToString(sortDirection),
    };
  }
}

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState>
    with HydratedMixin {
  final GraphQLClient _client;

  InvoicesBloc({required GraphQLClient client})
      : _client = client,
        super(const InvoicesInitial()) {
    on<LoadInvoices>(_mapLoadInvoicesToState);
    on<ToggleInvoiceSelection>(_mapToggleInvoiceSelectionToState);
  }

  @override
  InvoicesState fromJson(Map<String, dynamic> json) {
    try {
      return InvoicesState.fromJson(json);
    } catch (_) {
      return const InvoicesInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(InvoicesState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }

  Future<void> _mapLoadInvoicesToState(
      LoadInvoices event, Emitter<InvoicesState> emit) async {
    print('LoadInvoices event triggered');
    emit(const InvoicesLoading());

    try {
      final QueryOptions options = QueryOptions(
        document: gql(fetchInvoices),
        variables: {
          'first': event.queryParams.first,
          'sortBy': EnumConverters.sortByEnumToString(event.queryParams.sortBy),
          'sortDirection': EnumConverters.sortDirectionEnumToString(
              event.queryParams.sortDirection),
        },
      );

      final QueryResult result = await _client.query(options);
      print('Query result: $result');

      if (result.hasException) {
        print('Query exception: ${result.exception.toString()}');
        emit(const InvoicesError(message: 'Failed to load invoices'));
      } else {
        final List<Invoice> invoices =
            (result.data?['invoices']['edges'] as List)
                .map((edge) => Invoice.fromJson(edge['node']))
                .toList();

        print('Invoices fetched: ${invoices.length}');
        emit(InvoicesLoaded(
          invoices: invoices,
          selectedInvoices: const {},
        ));
      }
    } catch (e) {
      print('Failed to load invoices: $e');
      emit(const InvoicesError(message: 'Failed to load invoices'));
    }
  }

  void _mapToggleInvoiceSelectionToState(
      ToggleInvoiceSelection event, Emitter<InvoicesState> emit) {
    if (state is InvoicesLoaded) {
      final selectedInvoices =
          Set<String>.from((state as InvoicesLoaded).selectedInvoices);
      if (selectedInvoices.contains(event.invoiceId)) {
        selectedInvoices.remove(event.invoiceId);
      } else {
        selectedInvoices.add(event.invoiceId);
      }
      emit((state as InvoicesLoaded)
          .copyWith(selectedInvoices: selectedInvoices));
    }
  }
}
