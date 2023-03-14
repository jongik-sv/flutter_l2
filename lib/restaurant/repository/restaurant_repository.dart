import 'package:acutal/common/dio/dio.dart';
import 'package:acutal/common/model/cursor_pagination_model.dart';
import 'package:acutal/common/model/pagination_params.dart';
import 'package:acutal/common/repository/base_pagination_repository.dart';
import 'package:acutal/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    return repository;
  },
);

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  // http://$ip/restaurant
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  }); // 다른 함수를 만들때 RestaurantModel 부분만 바꾸면 됨

  // http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    // @Path('id') required String rid,
    @Path() required String id, // 변수명이 동일하면 Path안에 인자를 안넣어도 됨
  });
}
