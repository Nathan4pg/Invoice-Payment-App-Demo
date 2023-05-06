import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/screens/invoices_list_screen.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Invoices List',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<InvoicesBloc>(
        create: (context) => InvoicesBloc(
            client: GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('http://localhost:4000/graphql'),
        )),
        child: Scaffold(
          appBar: AppBar(title: const Text('Invoices List')),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: InvoicesListScreen(),
          ),
        ),
      ),
    );
  }
}
