import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/checkout/presentation/pages/checkout_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

GraphQLClient _client() => GraphQLClient(
  link: HttpLink('https://example.com/graphql'),
  cache: GraphQLCache(store: InMemoryStore()),
);

class _SeededCartBloc extends CartBloc {
  _SeededCartBloc(CartModel cart)
    : super(repository: CartRepository(client: _client())) {
    emit(state.copyWith(cart: cart));
  }

  @override
  void add(CartEvent event) {}
}

void main() {
  testWidgets('checkout does not overflow on a narrow phone in Spanish', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(720, 8000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final overflows = <String>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('overflowed')) {
        overflows.add(message.split('\n').first);
      }
    };

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                AuthBloc(repository: AuthRepository(client: _client())),
          ),
          BlocProvider<CartBloc>(
            create: (_) => _SeededCartBloc(
              const CartModel(
                id: 1,
                subtotal: 123150,
                formattedSubtotal: r'$ 123,150.00',
                grandTotal: 123150,
                formattedGrandTotal: r'$ 123,150.00',
                itemsCount: 1,
                itemsQty: 10,
                items: [
                  CartItemModel(
                    id: 1,
                    cartId: 1,
                    productId: 255,
                    name: 'Kit para paneles solares',
                    price: 12315,
                    formattedPrice: r'$ 12,315.00',
                    total: 123150,
                    formattedTotal: r'$ 123,150.00',
                    quantity: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CheckoutPage(),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    FlutterError.onError = previousOnError;

    expect(find.text('Selecciona primero un método de envío'), findsOneWidget);
    expect(overflows, isEmpty);
  });
}
