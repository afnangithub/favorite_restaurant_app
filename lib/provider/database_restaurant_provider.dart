import 'package:favorite_restaurant_app/data/db/restaurant_database_helper.dart';
import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:favorite_restaurant_app/utils/result_state.dart';
import 'package:flutter/foundation.dart';

class DatabaseRestaurantProvider extends ChangeNotifier {
  final RestaurantDatabaseHelper restaurantDatabaseHelper;

  DatabaseRestaurantProvider({required this.restaurantDatabaseHelper}) {
    _getFavorities();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorities = [];
  List<Restaurant> get favorities => _favorities;

  void _getFavorities() async {
    _favorities = await restaurantDatabaseHelper.getFavorities();
    if (_favorities.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavoritie(Restaurant restaurant) async {
    try {
      await restaurantDatabaseHelper.insertFavoritie(restaurant);
      _getFavorities();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritieRestaurant =
        await restaurantDatabaseHelper.getFavoritieByID(id);
    return favoritieRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await restaurantDatabaseHelper.removeFavoritie(id);
      _getFavorities();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
