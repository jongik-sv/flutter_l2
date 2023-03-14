import 'package:acutal/common/dio/dio.dart';
import 'package:acutal/common/repository/base_pagination_repository.dart';
import 'package:acutal/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider = Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
  return repository;
});

// http://$ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) = _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  }); // 다른 함수를 만들때 RestaurantModel 부분만 바꾸면 됨
}
