import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/screens/invoices_list_screen.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

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
          ),
        ),
        child: Scaffold(
          appBar: AppBar(title: const Text('Invoices List')),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: InvoicesListScreen(
              key: ValueKey('invoices_list_screen_key'),
            ),
          ),
        ),
      ),
    );
  }
}




// NOTE: Working example without bloc pattern
// --------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_invoice_app/screens/invoices_list_screen.dart';
// import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
// import 'package:flutter_invoice_app/widgets/test_widget_api_call.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Invoices List',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: BlocProvider<InvoicesBloc>(
//         create: (context) => InvoicesBloc(
//             client: GraphQLClient(
//           cache: GraphQLCache(),
//           link: HttpLink('http://localhost:4000/graphql'),
//         )),
//         child: Scaffold(
//           appBar: AppBar(title: const Text('Invoices List')),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: const [
//                 Expanded(child: FutureBuilderWidget()),
//                 Expanded(child: InvoicesListScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
