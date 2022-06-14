import 'package:favorite_restaurant_app/ui/z_restaurant_search_page.dart';
import 'package:flutter/material.dart';
//import 'package:favorite_restaurant_app/ui/restaurant_search_page.dart';

class SearchPage extends StatelessWidget {
  static const String searchTitle = 'Search';
  @override
  Widget build(BuildContext context) {
    return SearchForm();
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RestaurantSearchPage.routeName,
              arguments: myController.text);
        },
        tooltip: 'Search Restaurant!',
        child: const Icon(Icons.search),
      ),
    );
  }
}
