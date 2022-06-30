import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';

class RestaurantListFunction {
  bool error;
  String message;
  int count;
  List<Restaurants> restaurants;

  RestaurantListFunction({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListFunction.fromJson(Map<String, dynamic> json) =>
      RestaurantListFunction(
        message: json['message'],
        count: json['count'],
        error: json['error'],
        restaurants: List<Restaurants>.from(
          json['restaurants'].map((x) => Restaurants.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'count': count,
        'restaurants': List<dynamic>.from(restaurants.map((e) => e.toJson())),
      };
}
