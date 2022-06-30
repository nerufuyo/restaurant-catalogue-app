import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_database_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/static_data.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_detail_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/custom_card_widget.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/platform_widget.dart';

class RestaurantFavoriteScreen extends StatelessWidget {
  static const String routeName = '/restaurant_favorite';

  const RestaurantFavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(appBar: _statusBarApplication(), body: _buildList(context));
  }

  AppBar _statusBarApplication() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorite Restaurant',
            style: appTextStyle,
          ),
          Text(
            'Your favorite Restaurant!',
            style: subTitleTextStyle,
          )
        ],
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorite Restaurant'),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantDatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorite.length,
            itemBuilder: (context, index) {
              final result = provider.favorite[index];
              return RestaurantCardWidget(
                  pictureId: smallImageUrl + result.pictureId,
                  name: result.name,
                  city: result.city,
                  rating: result.rating,
                  onPress: () {
                    Navigator.pushNamed(
                        context, RestaurantDetailScreen.routeName,
                        arguments: result);
                  });
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "The favorite data doesn't exist yet",
                  style: titleTextStyle,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
