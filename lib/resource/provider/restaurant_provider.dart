import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_list_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantDatabaseApi api;
  RestaurantProvider({required this.api}) {
    fetchAllRestaurant();
  }

  String _errorMessage = '';
  String get message => _errorMessage;

  late ResultState _stateDatabase;
  ResultState get state => _stateDatabase;

  late RestaurantListFunction _restaurants;
  RestaurantListFunction get restaurants => _restaurants;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _stateDatabase = ResultState.loading;
      notifyListeners();
      final restaurant = await api.getTopHeadLines(Client());
      if (restaurant.restaurants.isEmpty) {
        _stateDatabase = ResultState.noData;
        notifyListeners();
        return _errorMessage = 'Not Found Data';
      } else {
        _stateDatabase = ResultState.hasData;
        notifyListeners();
        return _restaurants = restaurant;
      }
    } catch (e) {
      _stateDatabase = ResultState.error;
      notifyListeners();
      return _errorMessage = 'Error -> $e';
    }
  }
}
