import 'package:favorite_restaurant_app/provider/database_restaurant_provider.dart';
import 'package:favorite_restaurant_app/utils/result_state.dart';
import 'package:favorite_restaurant_app/widgets/card_restaurant.dart';
import 'package:favorite_restaurant_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  static const String favoritesTitle = 'Favorites';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(favoritesTitle)), body: _buildList());
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(favoritesTitle)),
        child: _buildList());
  }

  Widget _buildList() {
    return Consumer<DatabaseRestaurantProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.HasData) {
          return ListView.builder(
              itemCount: provider.favorities.length,
              itemBuilder: (context, index) {
                return CardRestaurant(restaurant: provider.favorities[index]);
              });
        } else if (provider.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.NoData) {
          return Center(child: Text(provider.message));
        } else if (provider.state == ResultState.Error) {
          return Center(child: Text("No Internet"));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
