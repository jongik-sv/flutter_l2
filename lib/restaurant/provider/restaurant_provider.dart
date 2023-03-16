import 'package:acutal/common/model/cursor_pagination_model.dart';
import 'package:acutal/common/providor/pagination_provider.dart';
import 'package:acutal/restaurant/model/restaurant_detail_model.dart';
import 'package:acutal/restaurant/model/restaurant_model.dart';
import 'package:acutal/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  /// restaurantProvider 가 변하면 Detail도 같이 빌드되어야 됨
  /// 그래서 watch를 사용
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  // collection.dart 를 import해야 함
  return state.data.firstWhereOrNull((element) => element.id == id);
});

/// provider에 제네릭은
/// 첫 번째는 notifier 클래스
/// 두 번째는 notifier 에서 관리하는 데이터 타입
/// 여기서는 <RestaurantStateNotifier, CursorPaginationBase>
/// 인자는 함수를 받는다. 인자가 되는 함수는 ref를 받아서 notifier를 리턴하는 함수 이다.
final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

/// super() 들어가는 것은 관리하는 데이터 타입의 초기 값이 들어감
class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  // super() 안에 들어가는 것은 StateNotifier<CursorPaginationBase> 에서의 CursorPaginationBase 이다
  RestaurantStateNotifier({required super.repository});

  void getDetail({required String id}) async {
    // 데이터가 없다면(CursorPagination 아니면) 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐때 그냥 리턴(위에서 했는데도)
    if (state is! CursorPagination) {
      return;
    }

    // 이하가 진짜 로직, 이 후는 CursorPagination으로 볼 수 있다.

    final pState = state as CursorPagination;

    // 내가 작성한 코드 Detail이면 새로 받을 필요 없지 않나?
    if (pState.data.firstWhere((e) => e.id == id) is RestaurantDetailModel) return;

    final resp = await (repository.getRestaurantDetail(id: id));

    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[...pState.data, resp],
      );
    } else {
      state = pState.copyWith(data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList());
    }
  }
}

// int fetchCount = 20,
// bool fetchMore = false,
