import 'package:acutal/common/component/pagination_list_view.dart';
import 'package:acutal/restaurant/component/restaurant_card.dart';
import 'package:acutal/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../provider/restaurant_provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(RestaurantDetailScreen.routeName,
            params: {
              'rid': model.id,
            });
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },


    );
  }
}
