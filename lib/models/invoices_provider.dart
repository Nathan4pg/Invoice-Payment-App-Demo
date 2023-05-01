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

  // print("invoices should be: ${result.data?['invoices']}");
  // print("hhhhnnnngggg: ${edges.map((dynamic edge) => )}")
  // print('edges: $edges');

  // FIXME: Code fails past this point
  final invoices =
      edges.map((dynamic edge) => Invoice.fromJson(edge['node'])).toList();

  // THIS RETURNS NOTHING!!!
  edges.map((dynamic edge) => print("edge: ${Invoice.fromJson(edge['node'])}"));

  // FIXME: This seems to be the big problem, this isn't returning
  // that suggests there is an issue in the invoices variable above
  print('invoices: $invoices');

  return invoices;
});

class SortByEnum {
  final String value;

  const SortByEnum._(this.value);

  static const DUE_DATE_ASC = SortByEnum._('DUE_DATE_ASC');
  static const DUE_DATE_DESC = SortByEnum._('DUE_DATE_DESC');

  @override
  String toString() => value;
}

class SortDirectionEnum {
  final String value;

  const SortDirectionEnum._(this.value);

  static const ASC = SortDirectionEnum._('ASC');
  static const DESC = SortDirectionEnum._('DESC');

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
    this.sortBy = SortByEnum.DUE_DATE_ASC,
    this.sortDirection = SortDirectionEnum.ASC,
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
    return Invoice(
      id: json['id'] as String,
      amount: json['amount'] as String,
      paid: json['paid'] as bool,
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidDate: json['paidDate'] != null
          ? DateTime.parse(json['paidDate'] as String)
          : null,
      grossAmount: json['grossAmount'] as String,
      invoicedDate: DateTime.parse(json['invoicedDate'] as String),
      orderNumber: json['orderNumber'] as String,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      salesRepresentative: json['salesRepresentative'] as String,
      shippingCompany: json['shippingCompany'] as String,
      shipmentTrackingId: json['shipmentTrackingId'] as String,
    );
  }
}
