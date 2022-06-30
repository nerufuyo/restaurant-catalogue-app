import 'package:flutter/material.dart';
import 'dart:async';
import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_detail_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantDatabaseApi api;

  RestaurantDetailProvider({
    required this.api,
  });

  late RestaurantDetailFunction _restaurantDetailsResponse;
  RestaurantDetailFunction get result => _restaurantDetailsResponse;

  String _errorMessage = '';
  String get message => _errorMessage;

  ResultState? _stateDatabase;
  ResultState? get state => _stateDatabase;

  Future<dynamic> getDetails(String id) async {
    try {
      _stateDatabase = ResultState.loading;
      notifyListeners();
      final restaurants = await api.getDetails(id);
      if (restaurants.restaurant.id.isEmpty) {
        _stateDatabase = ResultState.noData;
        notifyListeners();
        return _errorMessage = 'Not Found Data';
      } else {
        _stateDatabase = ResultState.hasData;
        notifyListeners();
        return _restaurantDetailsResponse = restaurants;
      }
    } catch (e) {
      _stateDatabase = ResultState.error;
      notifyListeners();
      return _errorMessage = 'Error -> $e';
    }
  }
}
