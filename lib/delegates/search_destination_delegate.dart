import 'package:maps_app/models/models.dart' as models;
import 'package:flutter/material.dart';

class SearchDestinationDelegate extends SearchDelegate<models.SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          final result = models.SearchResult(cancel: true);
          close(context, result);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          ),
          title: const Text(
            'Colocar ubicación manualmente',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            final result = models.SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        )
      ],
    );
  }
}
