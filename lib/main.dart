import 'package:flutter/material.dart';
import 'package:flutter_invoice_app/screens/invoices_list_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: InvoicesListScreen(),
        ),
      ),
    );
  }
}
