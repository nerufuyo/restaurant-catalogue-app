import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_detail_model.dart';

class RestaurantDetailFunction {
  bool error;
  String message;
  Restaurant restaurant;

  RestaurantDetailFunction(
      {required this.error, required this.message, required this.restaurant});

  factory RestaurantDetailFunction.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailFunction(
        error: json['error'],
        message: json['message'],
        restaurant: Restaurant.fromJsonDetail(json['restaurant']),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'restaurant': restaurant.toJson(),
      };
}
