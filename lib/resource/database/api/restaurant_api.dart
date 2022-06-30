// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_detail_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_list_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_search_response.dart';

class RestaurantDatabaseApi {
  static const baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const restaurantList = 'list';

  ///get restaurant list
  Future<RestaurantListFunction> getTopHeadLines(http.Client client) async {
    final response = await client.get(Uri.parse(baseUrl + restaurantList));
    try {
      if (response.statusCode == 200) {
        return RestaurantListFunction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load top headlines');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// search restaurant
  Future<RestaurantSearchFunction> getSearch(String query) async {
    final response = await http.get(Uri.parse("${baseUrl}search?q=${query}"));
    try {
      if (response.statusCode == 200) {
        return RestaurantSearchFunction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load result search.');
      }
    } on Error {
      rethrow;
    }
  }

  Future<RestaurantDetailFunction> getDetails(String id) async {
    final response = await http
        .get(Uri.parse(baseUrl + 'detail/$id'))
        .timeout((const Duration(seconds: 5)));
    try {
      if (response.statusCode == 200) {
        return RestaurantDetailFunction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load details.');
      }
    } on Error {
      rethrow;
    }
  }
}
