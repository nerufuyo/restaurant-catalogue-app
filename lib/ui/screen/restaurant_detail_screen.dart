import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_detail_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/custom_favorite_button_widget.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/platform_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_detail_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/static_data.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final Restaurants restaurant;

  const RestaurantDetailScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      RestaurantDetailProvider provider = Provider.of<RestaurantDetailProvider>(
        context,
        listen: false,
      );
      provider.getDetails(widget.restaurant.id);
    });
    super.initState();
  }

  Widget _buildDetails(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        _restaurantImage(screenWidth),
        Container(
          margin: const EdgeInsets.only(top: 100),
          child: DraggableScrollableSheet(builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<RestaurantDetailProvider>(
                          builder: (context, provider, _) {
                            if (provider.state == ResultState.loading) {
                              return _loadingState();
                            } else if (provider.state == ResultState.hasData) {
                              final response = provider.result.restaurant;
                              final responseFavorite = Restaurants(
                                  id: response.id,
                                  name: response.name,
                                  description: response.description,
                                  pictureId: response.pictureId,
                                  city: response.city,
                                  rating: response.rating);
                              return _hasDataState(
                                  context, response, responseFavorite);
                            } else if (provider.state == ResultState.noData) {
                              return _noDataState();
                            } else if (provider.state == ResultState.error) {
                              return _errorState();
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: bloodRed,
                  ),
                  child: const Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox _restaurantImage(double screenWidth) {
    return SizedBox(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        width: screenWidth,
        image: '$largeImageUrl${widget.restaurant.pictureId}',
        fit: BoxFit.cover,
        height: 500,
      ),
    );
  }

  Center _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 50,
          ),
          Text(
            'No Internet Connection\nPlease Check Your Internet Connection',
            textAlign: TextAlign.center,
            style: subTitleTextStyle,
          )
        ],
      ),
    );
  }

  Center _noDataState() {
    return const Center(
      child: Text('Not Found Data'),
    );
  }

  Center _loadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Stack _hasDataState(
      BuildContext context, Restaurant response, Restaurants responseFavorite) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _divider2(),
                          _restaurantNameAndFavorite(
                              response, responseFavorite),
                          _restaurantRating(response),
                          _divider2(),
                          _restaurantLocation(response),
                          _restaurantDescription(response),
                          _restaurantMenu(context, response),
                          _restaurantReview(response)
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  Column _restaurantReview(Restaurant response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_reviewTitle(), _reviewInformation(response)],
    );
  }

  SizedBox _reviewInformation(Restaurant response) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: response.customerReviews.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 200,
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Column(children: [
                      _reviewerName(response, index),
                      _reviewerDate(response, index),
                      _reviewerComment(response, index)
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Text _reviewTitle() {
    return Text(
      'Review',
      style: subTitleTextStyle,
    );
  }

  Text _reviewerComment(Restaurant response, int index) {
    return Text(
      response.customerReviews[index].review,
      style: reviewTextStyle,
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }

  Text _reviewerDate(Restaurant response, int index) {
    return Text(
      response.customerReviews[index].date,
      style: dateTextStyle,
    );
  }

  Text _reviewerName(Restaurant response, int index) {
    return Text(
      response.customerReviews[index].name,
      style: subTitleTextStyle,
    );
  }

  SizedBox _divider2() {
    return const SizedBox(
      height: 15,
    );
  }

  Padding _restaurantMenu(BuildContext context, Restaurant response) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          _foodTitle(),
          _buildFoodMenu(context, response.menus.foods),
          _divider(),
          _drinkTitle(),
          _buildDrinkMenu(context, response.menus.drinks),
        ],
      ),
    );
  }

  Text _drinkTitle() {
    return Text(
      'Drinks',
      style: subTitleTextStyle,
    );
  }

  SizedBox _divider() {
    return const SizedBox(
      height: 10,
    );
  }

  Text _foodTitle() {
    return Text(
      'Foods',
      style: subTitleTextStyle,
    );
  }

  Column _restaurantDescription(Restaurant response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          response.description,
          textAlign: TextAlign.justify,
          style: informationTextStyle,
        ),
      ],
    );
  }

  Row _restaurantLocation(Restaurant response) {
    return Row(
      children: [
        const Icon(
          Icons.location_pin,
          size: 24,
          color: Colors.red,
        ),
        Text(
          response.city,
          style: subTitleTextStyle,
        ),
      ],
    );
  }

  Row _restaurantRating(Restaurant response) {
    return Row(
      children: [
        Text(
          '${response.rating} / 5.0',
          style: subTitleTextStyle,
        ),
        const SizedBox(
          width: 8,
        ),
        RatingBar.builder(
            initialRating: response.rating,
            allowHalfRating: true,
            ignoreGestures: true,
            minRating: 1,
            maxRating: 5,
            itemCount: 5,
            itemSize: 20,
            itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
            onRatingUpdate: (rating) {})
      ],
    );
  }

  Row _restaurantNameAndFavorite(
      Restaurant response, Restaurants responseFavorite) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _restaurantName(response),
        FavoriteButton(favorite: responseFavorite),
      ],
    );
  }

  Text _restaurantName(Restaurant response) {
    return Text(
      response.name,
      style: titleTextStyle,
    );
  }

  Widget _buildFoodMenu(BuildContext context, List<Category> foods) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(foods[index].name)],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildDrinkMenu(BuildContext context, List<Category> foods) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(foods[index].name)],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildDetails(context);
  }

  Widget _buildIos(BuildContext context) {
    return _buildDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
