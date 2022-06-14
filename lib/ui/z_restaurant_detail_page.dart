import 'package:favorite_restaurant_app/common/navigation.dart';
import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:favorite_restaurant_app/ui/z_restaurant_view.dart';
import 'package:flutter/material.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Restaurant'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: restaurant.pictureId,
                child: Image.network(
                    "https://restaurant-api.dicoding.dev/images/medium/" +
                        restaurant.pictureId)),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Divider(color: Colors.grey),
                  Text(
                    'Name: ${restaurant.name}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Divider(color: Colors.grey),
                  Text(
                    'City: ${restaurant.city}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: ${restaurant.rating}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Read more'),
                    onPressed: () {
                      Navigation.intentWithData(
                        RestaurantView.routeName,
                        restaurant.id,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
