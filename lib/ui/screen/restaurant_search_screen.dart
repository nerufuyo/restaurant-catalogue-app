import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/restaurant_search_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/enum_state.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/static_data.dart';
import 'package:restaurant_catalog_submission_akhir/ui/screen/restaurant_detail_screen.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/custom_card_widget.dart';

class RestaurantSearchScreen extends StatefulWidget {
  static const routeName = '/restaurant_search';

  const RestaurantSearchScreen({Key? key}) : super(key: key);

  @override
  _RestaurantSearchScreenState createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  String queries = '';
  final TextEditingController _controller = TextEditingController();

  Widget _listSearch(BuildContext context) {
    return Consumer<RestaurantSearchProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          return _loadingState();
        } else if (provider.state == ResultState.hasData) {
          return _hasDataState(context, provider);
        } else if (provider.state == ResultState.noData) {
          return _noDataState(provider);
        } else if (provider.state == ResultState.error) {
          return _errorState();
        } else {
          return const Center(
            child: Text(''),
          );
        }
      },
    );
  }

  Center _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.search,
            size: 70,
          ),
          Text("Typed in the search section")
        ],
      ),
    );
  }

  Center _noDataState(RestaurantSearchProvider provider) {
    return Center(
      child: Text(provider.message),
    );
  }

  SizedBox _hasDataState(
      BuildContext context, RestaurantSearchProvider provider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: provider.result?.restaurants.length,
          itemBuilder: (context, index) {
            var response = provider.result!.restaurants[index];
            return RestaurantCardWidget(
                pictureId: smallImageUrl + response.pictureId,
                name: response.name,
                city: response.city,
                rating: response.rating,
                onPress: () {
                  Navigator.pushNamed(context, RestaurantDetailScreen.routeName,
                      arguments: response);
                });
          }),
    );
  }

  Center _loadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Center(
          child: Column(
        children: [
          Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      title: TextField(
                        controller: _controller,
                        onChanged: (String value) {
                          setState(() {
                            queries = value;
                          });
                          if (value != '') {
                            state.fetchSearchRestaurant(value);
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: "Search restaurant by name or menu",
                            border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (queries != '') {
                            _controller.clear();
                            setState(() {
                              queries = '';
                            });
                          }
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 30),
                      )));
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _listSearch(context),
            ),
          ),
        ],
      )),
    );
  }
}
