import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/widgets/product_info_section.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('rating and stock row does not overflow on a narrow phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1650);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final product = ProductModel.fromJson({
      'id': '/api/shop/products/255',
      '_id': 255,
      'type': 'simple',
      'name': 'Kit',
      'price': 315,
      'formattedPrice': r'$ 315.00',
      'isSaleable': true,
      'reviews': {'edges': []},
    });

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => AuthBloc(
          repository: AuthRepository(
            client: GraphQLClient(
              link: HttpLink('https://example.com/graphql'),
              cache: GraphQLCache(store: InMemoryStore()),
            ),
          ),
        ),
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductInfoSection(product: product),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Aún no hay reseñas'), findsOneWidget);
    expect(find.text('En stock'), findsOneWidget);
  });
}
