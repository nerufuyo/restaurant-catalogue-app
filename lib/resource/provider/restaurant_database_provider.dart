import 'package:flutter/material.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/helper/database_helper.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';

class RestaurantDatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  RestaurantDatabaseProvider({required this.databaseHelper}) {
    getFavorite();
  }

  ResultState? _stateDatabase;
  ResultState? get state => _stateDatabase;

  String _errorMessage = '';
  String get message => _errorMessage;

  List<Restaurants> _favorite = [];
  List<Restaurants> get favorite => _favorite;

  void getFavorite() async {
    _favorite = await databaseHelper.getFavorite();
    if (_favorite.isNotEmpty) {
      _stateDatabase = ResultState.hasData;
    } else {
      _stateDatabase = ResultState.noData;
      _errorMessage = "It's not there yet";
    }
    notifyListeners();
  }

  void addFavorite(Restaurants restaurants) async {
    try {
      await databaseHelper.insertFavorite(restaurants);
      getFavorite();
    } catch (e) {
      _stateDatabase = ResultState.error;
      _errorMessage = 'Error $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavoriteById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      getFavorite();
    } catch (e) {
      _stateDatabase = ResultState.error;
      _errorMessage = 'Error $e';
      notifyListeners();
    }
  }
}
