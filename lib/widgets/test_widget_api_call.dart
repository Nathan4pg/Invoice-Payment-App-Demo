import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FutureBuilderWidget extends StatelessWidget {
  const FutureBuilderWidget({Key? key}) : super(key: key);

  Future<QueryResult> fetchData() async {
    final HttpLink httpLink = HttpLink('http://localhost:4000/graphql');
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    const String query = r'''
      query GetInvoices {
        invoices {
          edges {
            node {
              id
              amount
              paid
              dueDate
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

    final QueryOptions options = QueryOptions(document: gql(query));
    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('Failed to load data: ${result.exception}');
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List invoices = snapshot.data!.data!['invoices']['edges'];
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index]['node'];
              return ListTile(
                title: Text('Invoice ID: ${invoice['id']}'),
                subtitle: Text('Amount: ${invoice['amount']}'),
              );
            },
          );
        }
      },
    );
  }
}
