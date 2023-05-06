import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoicesRepository {
  InvoicesRepository(this._client);

  final GraphQLClient _client;

  Future<List<Invoice>> fetchInvoices(InvoicesQueryParams queryParams) async {
    final result = await _client.query(QueryOptions(
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
    return edges.map((dynamic edge) => Invoice.fromJson(edge['node'])).toList();
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
