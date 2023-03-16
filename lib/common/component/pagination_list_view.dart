import 'package:acutal/common/model/cursor_pagination_model.dart';
import 'package:acutal/common/model/model_with_id.dart';
import 'package:acutal/common/providor/pagination_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/pagination_utils.dart';

typedef PaginationWidgetBuild<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuild<T> itemBuilder;

  const PaginationListView({required this.itemBuilder, Key? key, required this.provider}) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 처음 로딩일 때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(forceRefetch: true);
              },
              child: Text('다시시도')),
        ],
      );

      //   Center(
      //   child: Text(state.message),
      // );
    }

    final cp = state as CursorPagination<T>;

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
                child: cp is CursorPaginationFetchingMore ? CircularProgressIndicator() : Text('마지막 데이터 입니다..'),
              ),
            );
          }
          final pItem = cp.data[index];
          return widget.itemBuilder(context, index, pItem);
        },
      ),
    );
  }
}
