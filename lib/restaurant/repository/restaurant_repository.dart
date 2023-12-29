import 'package:code_factory_delivery/common/const/data.dart';
import 'package:code_factory_delivery/common/dio/dio.dart';
import 'package:code_factory_delivery/common/model/cursor_pagination_model.dart';
import 'package:code_factory_delivery/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory_delivery/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRepository(
    dio,
    baseUrl: 'http://$ip/restaurant',
  );

  return repository;
});

@RestApi()
abstract class RestaurantRepository {
  // baseUrl = http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPaginationModel<RestaurantModel>> paginate();

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id, // baseUrl 다음 경로, http://$ip/restaurant/id
  });
}
