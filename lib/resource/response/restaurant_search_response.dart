import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';

class RestaurantSearchFunction {
  bool error;
  int founded;
  List<Restaurants> restaurants;

  RestaurantSearchFunction({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchFunction.fromJson(Map<String, dynamic> json) =>
      RestaurantSearchFunction(
        error: json['error'],
        founded: json['founded'],
        restaurants: List<Restaurants>.from(
            json["restaurants"].map((x) => Restaurants.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'founded': founded,
        'restaurants': List<dynamic>.from(restaurants.map((x) => x.toJson()))
      };
}
