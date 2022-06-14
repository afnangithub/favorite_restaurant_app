import 'package:favorite_restaurant_app/common/navigation.dart';
import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:favorite_restaurant_app/provider/database_restaurant_provider.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRestaurantProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/medium/" +
                            restaurant.pictureId,
                        width: 100)),
                title: Text(
                  restaurant.name,
                ),
                subtitle: Text(
                  "Rating : " +
                      restaurant.rating.toString() +
                      "\n" +
                      "City : " +
                      restaurant.city,
                ),
                trailing: isFavorited
                    ? IconButton(
                        icon: Icon(Icons.favorite),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.removeFavorite(restaurant.id),
                      )
                    : IconButton(
                        icon: Icon(Icons.favorite_border),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.addFavoritie(restaurant),
                      ),
                onTap: () => Navigation.intentWithData(
                    RestaurantDetailPage.routeName, restaurant),
              ),
            );
          },
        );
      },
    );
  }
}
