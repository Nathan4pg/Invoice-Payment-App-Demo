import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final apolloClientProvider = Provider<GraphQLClient>((ref) {
  final link = HttpLink('http://localhost:4000/graphql');

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );
});

final invoicesQueryProvider = FutureProvider.autoDispose
    .family<List<Invoice>, InvoicesQueryParams>((ref, queryParams) async {
  final client = ref.read(apolloClientProvider);
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

  // print('invoices: $invoices');
  return invoices;
});

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

class Invoice {
  final String id;
  final String amount;
  final bool paid;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String grossAmount;
  final DateTime invoicedDate;
  final String orderNumber;
  final DateTime deliveryDate;
  final String salesRepresentative;
  final String shippingCompany;
  final String shipmentTrackingId;

  Invoice({
    required this.id,
    required this.amount,
    required this.paid,
    required this.dueDate,
    required this.paidDate,
    required this.grossAmount,
    required this.invoicedDate,
    required this.orderNumber,
    required this.deliveryDate,
    required this.salesRepresentative,
    required this.shippingCompany,
    required this.shipmentTrackingId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    try {
      return Invoice(
        id: json['id'] as String,
        amount: json['amount'] as String,
        paid: json['paid'] as bool,
        dueDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['dueDate'] as String)),
        paidDate: json['paidDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(json['paidDate'] as String))
            : null,
        grossAmount: json['grossAmount'] as String,
        invoicedDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['invoicedDate'] as String)),
        orderNumber: json['orderNumber'] as String,
        deliveryDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['deliveryDate'] as String)),
        salesRepresentative: json['salesRepresentative'] as String,
        shippingCompany: json['shippingCompany'] as String,
        shipmentTrackingId: json['shipmentTrackingId'] as String,
      );
    } catch (e) {
      // Handle the exception here, for example, log the error or return a default object
      print('Error parsing Invoice JSON: $e');
      return Invoice(
        id: '',
        amount: '0',
        paid: false,
        dueDate: DateTime.now(),
        paidDate: null,
        grossAmount: '0',
        invoicedDate: DateTime.now(),
        orderNumber: '',
        deliveryDate: DateTime.now(),
        salesRepresentative: '',
        shippingCompany: '',
        shipmentTrackingId: '',
      );
    }
  }
}
