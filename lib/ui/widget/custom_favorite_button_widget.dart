import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_database_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';

class FavoriteButton extends StatelessWidget {
  final Restaurants favorite;

  const FavoriteButton({Key? key, required this.favorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(favorite.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return isFavorite
                ? InkWell(
                    onTap: () {
                      provider.removeFavorite(favorite.id);
                      Fluttertoast.showToast(
                          msg: 'Remove from favorites!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: bloodRed,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      provider.addFavorite(favorite);
                      Fluttertoast.showToast(
                          msg: 'Successfully Added To Favorite!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: black,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
