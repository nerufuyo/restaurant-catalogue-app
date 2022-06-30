import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_catalog_submission_akhir/resource/database/api/restaurant_api.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_list_response.dart';

import 'json_parsing_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Fetch restaurant api', () {
    final restaurantTest = {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        },
      ]
    };

    test('must contain a list of restaurant when api successful', () async {
      final api = RestaurantDatabaseApi();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(RestaurantDatabaseApi.baseUrl +
              RestaurantDatabaseApi.restaurantList),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(restaurantTest), 200));

      expect(await api.getTopHeadLines(client), isA<RestaurantListFunction>());
    });

    test('must contain a list of restaurant when api failed', () {
      //arrange
      final api = RestaurantDatabaseApi();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(RestaurantDatabaseApi.baseUrl +
              RestaurantDatabaseApi.restaurantList),
        ),
      ).thenAnswer((_) async =>
          http.Response('Failed to load list of restaurants', 404));

      var restaurantActual = api.getTopHeadLines(client);
      expect(restaurantActual, throwsException);
    });

    test('must contain a list of restaurant when no internet connection', () {
      //arrange
      final api = RestaurantDatabaseApi();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(RestaurantDatabaseApi.baseUrl +
              RestaurantDatabaseApi.restaurantList),
        ),
      ).thenAnswer(
          (_) async => throw const SocketException('No Internet Connection'));

      var restaurantActual = api.getTopHeadLines(client);
      expect(restaurantActual, throwsException);
    });
  });
}
