import 'package:flutter/material.dart';
import 'package:flutter_invoice_app/widgets/invoices_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      home: Scaffold(
        appBar: AppBar(title: const Text('Invoices List')),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: InvoicesList(),
        ),
      ),
    );
  }
}
