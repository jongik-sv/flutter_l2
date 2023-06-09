import 'package:acutal/product/model/product_model.dart';
import 'package:acutal/product/provider/product_provider.dart';
import 'package:acutal/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/component/pagination_list_view.dart';
import '../component/product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(RestaurantDetailScreen.routeName, params: {
              'rid': model.restaurant.id
            });
          },
          child: ProductCard.fromProductModel(model: model),
        );
      },
      provider: productProvider,
    );
  }
}
