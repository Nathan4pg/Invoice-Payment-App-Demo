import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final apolloClientProvider = Provider<GraphQLClient>((ref) {
  final link = HttpLink('http://localhost:4000/graphql');

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );
});

final invoicesProvider = StateNotifierProvider.autoDispose.family<
    InvoicesListNotifier,
    AsyncValue<List<Invoice>>,
    InvoicesQueryParams>((ref, queryParams) {
  return InvoicesListNotifier(ref as ProviderRef, queryParams);
});

class InvoicesListNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  InvoicesListNotifier(this._ref, this._queryParams)
      : super(const AsyncValue.loading()) {
    _fetchInvoices();
  }

  final ProviderRef _ref; // Change this line
  final InvoicesQueryParams _queryParams;
  final List<Invoice> _invoices = [];
  String? _endCursor;

  Future<void> _fetchInvoices() async {
    try {
      final queryParams = InvoicesQueryParams(
        first: 10,
        after: _endCursor,
        sortBy: _queryParams.sortBy,
        sortDirection: _queryParams.sortDirection,
      );

      final client = _ref.read(apolloClientProvider);
      final result = await client.query(QueryOptions(
        document: gql('''
    query GetInvoices(\$first: Int, \$after: ID, \$sortBy: SortByEnum = DUE_DATE_ASC, \$sortDirection: SortDirectionEnum = ASC) {
      invoices(first: \$first, after: \$after, sortBy: \$sortBy, sortDirection: \$sortDirection) {
        edges {
          cursor
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
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  '''),
        variables: {
          'first': queryParams.first,
          'after': queryParams.after,
          'sortBy': queryParams.sortBy.toString(),
          'sortDirection': queryParams.sortDirection.toString(),
        },
      ));

      if (result.hasException) {
        throw Exception('Failed to fetch invoices: ${result.exception}');
      }

      final List<dynamic> edges = result.data?['invoices']['edges'];

      final invoices =
          edges.map((dynamic edge) => Invoice.fromJson(edge['node'])).toList();

      _invoices.addAll(invoices);
      _endCursor = invoices.last.dueDate.millisecondsSinceEpoch.toString();

      state = AsyncValue.data(_invoices);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  void loadMoreInvoices() {
    _fetchInvoices();
  }
}

class SortByEnum {
  final String value;

  const SortByEnum._(this.value);

  static const dueDateAsc = SortByEnum._('DUE_DATE_ASC');
  static const dueDateDesc = SortByEnum._('DUE_DATE_DESC');

  @override
  String toString() => value;
}

class SortDirectionEnum {
  final String value;

  const SortDirectionEnum._(this.value);

  static const asc = SortDirectionEnum._('ASC');
  static const desc = SortDirectionEnum._('DESC');

  @override
  String toString() => value;
}

class InvoicesQueryParams {
  final int? first;
  final String? after;
  final SortByEnum sortBy;
  final SortDirectionEnum sortDirection;

  InvoicesQueryParams({
    this.first,
    this.after,
    this.sortBy = SortByEnum.dueDateAsc,
    this.sortDirection = SortDirectionEnum.asc,
  });
}
