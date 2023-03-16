import 'package:acutal/common/layout/default_layout.dart';
import 'package:acutal/common/model/cursor_pagination_model.dart';
import 'package:acutal/product/component/product_card.dart';
import 'package:acutal/rating/component/rating_card.dart';
import 'package:acutal/restaurant/component/restaurant_card.dart';
import 'package:acutal/restaurant/model/restaurant_detail_model.dart';
import 'package:acutal/restaurant/provider/restaurant_provider.dart';
import 'package:acutal/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/utils/pagination_utils.dart';
import '../../rating/model/rating_model.dart';
import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Detail 생성 시 상세정보를 가져오게 한다.
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
        title: '불타는 떡볶이',
        child: CustomScrollView(
          controller: controller,
          slivers: [
            renderTop(model: state),
            if (state is! RestaurantDetailModel) renderLoading(),
            if (state is RestaurantDetailModel) renderLabel(),
            if (state is RestaurantDetailModel) renderProducts(products: state!.products),
            if (ratingsState is CursorPagination<RatingModel>) renderRatings(models: ratingsState.data),
          ],
        ));
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(model: models[index]),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 5,
              ),
            ),
          ),
        )),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding renderProducts({required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ProductCard.fromRestaurantProductModel(
              model: model,
            ),
          );
        }, childCount: products.length),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}

// image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
// name: '불타는 떡뽀끼',
// tags: ['떡1'],
// ratingsCount: 100,
// deliveryTime: 100,
// deliveryFee: 5000,
// ratings: 1.2,
// isDetail: true,
// detail: '맛있는 떡볶이',
