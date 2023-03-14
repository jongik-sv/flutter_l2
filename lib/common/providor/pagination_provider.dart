import 'package:acutal/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../model/pagination_params.dart';

abstract class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,

    /// true : 데이터 더 가져옴, false : 새로고침 (화면 유지한 상태에서 새로 고침)
    bool fetchMore = false,

    /// 강제로 다시 로딩, 화면의 내용 모두 지운 후  - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      /// 1) CursorPagination
      /// 2) CursorPaginationLoading
      /// 3) CursorPaginationError
      /// 4) CursorPaginationRefetching
      /// 5) CursorPaginationFetchingMore

      /// 바로 반환하는 상황
      /// 1) hasMore == false
      /// 2) 로딩중 - fetchMore == true
      ///            fetchMore != true -  새로고침의 의도가 있을 수 있다.
      ///

      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination<T>; // 캐스팅 이유는 . 을 눌러봐

        /// 이전에 온 데이터가 있지만, 더 이상 그 이 후 데이터가 없을 때
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      /// 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      /// PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      /// fetchMore
      if (fetchMore) {
        final pState = (state as CursorPagination<T>);
        state = CursorPaginationFetchingMore<T>(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      } else {
        /// 데이터를 처음 부터 가져온다.
        /// 데이터가 있다면 기존 데이터 보존한 채로 Fetch(API 요청) 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          /// 데이터를 유지할 필요가 없는 상황
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        /// 기존 + 새로운 데이터를 저장
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져 오지 못했습니다. ${e.toString()}');
    }
  }
}
