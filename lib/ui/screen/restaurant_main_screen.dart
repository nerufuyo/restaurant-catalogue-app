import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/static_data.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_detail_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_search_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/custom_card_widget.dart';

class RestaurantMainScreen extends StatelessWidget {
  const RestaurantMainScreen({Key? key}) : super(key: key);
  static const routeName = '/restaurant_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarApplication(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<RestaurantProvider>(builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                //loading widget
                return _loadingState();
              } else if (state.state == ResultState.error) {
                // error widget
                return _noInternetState();
              } else if (state.state == ResultState.noData) {
                // error No Data
                return _noDataState(state);
              } else if (state.state == ResultState.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: state.restaurants.count,
                    itemBuilder: (context, index) {
                      final response = state.restaurants.restaurants[index];
                      return RestaurantCardWidget(
                          pictureId: smallImageUrl + response.pictureId,
                          name: response.name,
                          city: response.city,
                          rating: response.rating,
                          onPress: () {
                            Navigator.pushNamed(
                                context, RestaurantDetailScreen.routeName,
                                arguments: response);
                          });
                    });
              } else {
                return const Text("");
              }
            }),
          ),
        ],
      ),
    );
  }

  Center _noDataState(RestaurantProvider state) =>
      Center(child: Text(state.message));

  Center _noInternetState() {
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

  Center _loadingState() => const Center(child: CircularProgressIndicator());

  AppBar _appBarApplication(BuildContext context) {
    return AppBar(
      elevation: 5,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Restaurant Catalogue",
            style: appTextStyle,
          ),
          Text(
            'Find your favorite Restaurants!',
            style: subAppTextStyle,
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RestaurantSearchScreen.routeName,
            );
          },
        ),
      ],
    );
  }
}
