import 'package:flutter_invoice_app/models/invoice_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum SortByEnum {
  dueDateAsc,
  dueDateDesc,
}

enum SortDirectionEnum {
  asc,
  desc,
}

extension SortByEnumExtension on SortByEnum {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension SortDirectionEnumExtension on SortDirectionEnum {
  String toShortString() {
    return toString().split('.').last;
  }
}

class InvoicesQueryParams {
  final int first;
  final SortByEnum sortBy;
  final SortDirectionEnum sortDirection;

  InvoicesQueryParams({
    required this.first,
    required this.sortBy,
    required this.sortDirection,
  });
}

class InvoicesRepository {
  final GraphQLClient client;

  InvoicesRepository({required this.client});

  Future<List<Invoice>> fetchInvoicesWithParams(
      InvoicesQueryParams queryParams) async {
    String readInvoicesQuery({
      required int first,
      required SortByEnum sortBy,
      required SortDirectionEnum sortDirection,
    }) {
      return '''
        query ReadInvoices(\$first: Int, \$sortBy: SortByEnum, \$sortDirection: SortDirectionEnum) {
          invoices(first: \$first, sortBy: \$sortBy, sortDirection: \$sortDirection) {
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
    }

    final response = await client.query(QueryOptions(
      document: gql(readInvoicesQuery(
        first: queryParams.first,
        sortBy: queryParams.sortBy,
        sortDirection: queryParams.sortDirection,
      )),
      variables: {
        'first': queryParams.first,
        'sortBy': queryParams.sortBy.toShortString(),
        'sortDirection': queryParams.sortDirection.toShortString(),
      },
    ));

    if (response.hasException) {
      throw Exception(response.exception.toString());
    }

    final invoicesJson = response.data?['invoices']['edges'];
    if (invoicesJson == null) {
      throw Exception('Error reading invoices');
    }

    return invoicesJson
        .map<Invoice>((invoiceJson) => Invoice.fromJson(invoiceJson['node']))
        .toList();
  }
}
