import 'package:acutal/common/utils/pagination_utils.dart';
import 'package:acutal/restaurant/component/restaurant_card.dart';
import 'package:acutal/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../provider/restaurant_provider.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치이면 새로운 데이터 요청
    // if (controller.offset > controller.position.maxScrollExtent - 300) {
    //   print('${controller.offset} : ${controller.position.maxScrollExtent - 300}');
    //   ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    /// watch를 하면 state가 그대로 주입된다.
    /// 여기서는 CursorPaginationBase
    ///
    final data = ref.watch(restaurantProvider);

    // 처음 로딩일 때
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Center(
                child: data is CursorPaginationFetchingMore ? CircularProgressIndicator() : Text('마지막 데이터 입니다..'),
              ),
            );
          }
          final pItem = cp.data[index];
          return GestureDetector(
            child: RestaurantCard.fromModel(model: pItem),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: pItem.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
