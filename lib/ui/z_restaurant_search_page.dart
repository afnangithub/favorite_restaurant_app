import 'package:favorite_restaurant_app/common/styles.dart';
import 'package:favorite_restaurant_app/provider/restaurant_provider.dart';
import 'package:favorite_restaurant_app/data/api/restaurant_api_service.dart';
import 'package:favorite_restaurant_app/widgets/card_restaurant.dart';
import 'package:favorite_restaurant_app/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/restaurant_search';
  static const String _headlineText = 'Search Restaurant';

  final String query;

  const RestaurantSearchPage({required this.query});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_headlineText),
      ),
      body: ChangeNotifierProvider<SearchRestaurantProvider>(
        create: (_) => SearchRestaurantProvider(
          apiService: ApiService(),
          query: query,
        ),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text("No Internet"));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}
