import 'dart:async';
import 'package:code_factory_delivery/restaurant/model/restaurant_model.dart';
import 'package:code_factory_delivery/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    AsyncNotifierProvider<RestaurantNotifier, List<RestaurantModel>>(() {
  return RestaurantNotifier();
});

class RestaurantNotifier extends AsyncNotifier<List<RestaurantModel>> {
  // RestaurantNotifier({required this.repository});

  // paginate() async {
  //   final resp = await repository.paginate();

  //   state = resp.data;
  // }

  @override
  FutureOr<List<RestaurantModel>> build() async {
    final repository = ref.watch(restaurantRepositoryProvider);
    final resp = await repository.paginate();

    return resp.data;
  }
}
