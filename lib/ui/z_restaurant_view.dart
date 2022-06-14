import 'package:favorite_restaurant_app/common/styles.dart';
import 'package:favorite_restaurant_app/data/api/restaurant_api_service.dart';
import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:favorite_restaurant_app/utils/result_state.dart';
import 'package:favorite_restaurant_app/provider/restaurant_provider.dart';
import 'package:favorite_restaurant_app/widgets/custom_sliver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantView extends StatelessWidget {
  static const routeName = '/restaurant_view';
  final String id;
  const RestaurantView({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View Restaurant'),
        ),
        body: ChangeNotifierProvider<DetailRestaurantProvider>(
            create: (_) =>
                DetailRestaurantProvider(apiService: ApiService(), id: id),
            child: _buildList()));
  }

  Widget _buildList() {
    return Consumer<DetailRestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.HasData) {
        return RestaurantViewList(restaurant: state.result.restaurant);
      } else if (state.state == ResultState.NoData) {
        return Center(child: Text(state.message));
      } else if (state.state == ResultState.Error) {
        return Center(child: Text("No Internet"));
      } else {
        return Center(child: Text(''));
      }
    });
  }
}

class RestaurantViewList extends StatelessWidget {
  final RestaurantDetail restaurant;
  const RestaurantViewList({required this.restaurant});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        Hero(
            tag: restaurant.pictureId,
            child: Image.network(
                "https://restaurant-api.dicoding.dev/images/medium/" +
                    restaurant.pictureId))
      ])),
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Id: ${restaurant.id}',
                      style: Theme.of(context).textTheme.headline6),
                  const Divider(color: Colors.grey),
                  Text('Name: ${restaurant.name}',
                      style: Theme.of(context).textTheme.headline6),
                  const Divider(color: Colors.grey),
                  Text('Description: ${restaurant.description}',
                      style: Theme.of(context).textTheme.subtitle1),
                  const Divider(color: Colors.grey),
                  Text('City: ${restaurant.city}',
                      style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: 10),
                  Text('Rating: ${restaurant.rating}',
                      style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      _headerX('Categories'),
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: restaurant.categories.map(_buildTileCategory).toList(),
            ))
      ])),
      _headerX('Menu Foods'),
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: restaurant.menus.foods.map(_buildTileCategory).toList(),
            ))
      ])),
      _headerX('Menu Drinks'),
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  restaurant.menus.drinks.map(_buildTileCategory).toList(),
            ))
      ])),
      _headerX('Review'),
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: restaurant.customerReviews
                  .map(_buildTileCustomerReview)
                  .toList(),
            ))
      ])),
      _header('End Menu'),
    ]);
  }

  SliverPersistentHeader _header(String text) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            minHeight: 60,
            maxHeight: 150,
            child: Container(
                color: secondaryColor,
                child: Center(
                    child: Text(text,
                        style: const TextStyle(color: Colors.white))))));
  }

  SliverPersistentHeader _headerX(String text) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            minHeight: 60,
            maxHeight: 80,
            child: Container(
                color: darkSecondaryColor,
                child: Center(
                    child: Text(text,
                        style: const TextStyle(color: Colors.white))))));
  }

  Widget _buildTileCategory(Category category) {
    return Text(category.name);
  }

  Widget _buildTileCustomerReview(CustomerReview customerReview) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(customerReview.name + "Date : " + customerReview.date),
      subtitle: Text("Review : " + customerReview.review),
    );
  }
}
