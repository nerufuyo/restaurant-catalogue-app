import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantCardWidget extends StatefulWidget {
  final String pictureId;
  final String name;
  final String city;
  final double rating;
  final Function() onPress;

  const RestaurantCardWidget({
    Key? key,
    required this.pictureId,
    required this.name,
    required this.city,
    required this.rating,
    required this.onPress,
  }) : super(key: key);

  @override
  _RestaurantCardWidgetState createState() => _RestaurantCardWidgetState();
}

class _RestaurantCardWidgetState extends State<RestaurantCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: InkWell(
            onTap: widget.onPress,
            child: Row(
              children: [_restaurantImage(), _restaurantInformation()],
            ),
          ),
        ),
      ),
    );
  }

  Padding _restaurantInformation() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _restaurantName(),
          _divider(),
          _restaurantLocation(),
          _divider(),
          _restaurantRating()
        ],
      ),
    );
  }

  SizedBox _divider() {
    return const SizedBox(
      height: 2,
    );
  }

  Row _restaurantRating() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.rating.toString(),
          style: informationTextStyle,
        ),
        const SizedBox(
          width: 5,
        ),
        RatingBar.builder(
            allowHalfRating: true,
            ignoreGestures: true,
            minRating: 1,
            maxRating: 5,
            itemCount: 5,
            itemSize: 14,
            initialRating: widget.rating,
            itemBuilder: (context, _) => const Icon(Icons.star),
            onRatingUpdate: (rating) {})
      ],
    );
  }

  Row _restaurantLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 15,
        ),
        Text(
          widget.city,
          style: informationTextStyle,
        ),
      ],
    );
  }

  Text _restaurantName() {
    return Text(
      widget.name,
      style: subTitleTextStyle,
    );
  }

  ClipRRect _restaurantImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: widget.pictureId,
        height: 100,
        width: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}
