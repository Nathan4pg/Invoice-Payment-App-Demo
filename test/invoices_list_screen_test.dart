import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_bloc.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_event.dart';
import 'package:flutter_invoice_app/bloc/invoices/invoices_state.dart';
import 'package:flutter_invoice_app/constants/enums.dart';
import 'package:flutter_invoice_app/screens/invoices_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_invoice_app/mocks/invoices_list_screen_test.mocks.dart';

@GenerateMocks([InvoicesBloc])
void main() {
  group(
    'InvoicesListScreen',
    () {
      late InvoicesBloc invoicesBloc;

      setUp(() {
        invoicesBloc = MockInvoicesBloc();
      });

      testWidgets('loads invoices', (WidgetTester tester) async {
        when(invoicesBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            const InvoicesLoading(),
            const InvoicesLoaded(invoices: []),
          ]),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: invoicesBloc,
              child: const InvoicesListScreen(
                  key: ValueKey('invoices_list_screen_key')),
            ),
          ),
        );

        verify(
          invoicesBloc.add(LoadInvoices(
            queryParams: InvoicesQueryParams(
              first: 10,
              sortBy: SortByEnum.dueDateDesc,
              sortDirection: SortDirectionEnum.desc,
            ),
          )),
        ).called(1);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsNWidgets(0));
      });
    },
  );
}
