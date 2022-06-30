import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_search_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantDatabaseApi api;

  RestaurantSearchProvider({required this.api}) {
    fetchSearchRestaurant(query);
  }
  String _queryDatabase = '';
  String get query => _queryDatabase;

  String _errorMessage = '';
  String get message => _errorMessage;

  RestaurantSearchFunction? _restoPencarianProvider;
  RestaurantSearchFunction? get result => _restoPencarianProvider;

  ResultState? _state;
  ResultState? get state => _state;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      _queryDatabase = query;

      final restaurantSearch = await api.getSearch(query);
      if (restaurantSearch.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _errorMessage = 'Yah, Resto Yang Kamu Cari Ga ada nih :(';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restoPencarianProvider = restaurantSearch;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _errorMessage = 'Error -> $e';
    }
  }
}
