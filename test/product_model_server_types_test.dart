import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/product/presentation/bloc/product_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('values typed differently by the live server', () {
    test('image position returned as int does not break product parsing', () {
      final product = ProductModel.fromJson({
        'id': '/api/shop/products/255',
        '_id': 255,
        'type': 'simple',
        'name': 'Kit',
        'isSaleable': true,
        'images': {
          'edges': [
            {
              'node': {
                'id': '/api/shop/product-images/424',
                '_id': 424,
                'path': 'products/255/1001679899.webp',
                'publicPath': 'https://example.com/1001679899.webp',
                'type': 'images',
                'position': 1,
              },
            },
          ],
        },
      });

      expect(product.images.single.position, '1');
      expect(product.allImageUrls, isNotEmpty);
    });

    test('image position returned as string stays unchanged', () {
      final image = ProductImage.fromJson({'id': '1', 'position': '2'});

      expect(image.position, '2');
    });

    test('variant isSaleable returned as bool keeps stock state correct', () {
      ProductVariant variant(bool saleable) =>
          ProductVariant.fromJson({'id': '5', 'isSaleable': saleable});

      expect(
        ProductDetailState(selectedVariant: variant(true)).isOutOfStock,
        isFalse,
      );
      expect(
        ProductDetailState(selectedVariant: variant(false)).isOutOfStock,
        isTrue,
      );
    });
  });
}
