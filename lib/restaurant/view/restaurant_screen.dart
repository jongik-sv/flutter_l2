import 'package:acutal/common/component/pagination_list_view.dart';
import 'package:acutal/restaurant/component/restaurant_card.dart';
import 'package:acutal/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

import '../provider/restaurant_provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      itemBuilder: <RestaurantModel>(context, index, model) {
        return GestureDetector(
          child: RestaurantCard.fromModel(model: model),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.id),
              ),
            );
          },
        );
      },
      provider: restaurantProvider,
    );
  }
}
