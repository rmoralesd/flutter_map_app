import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
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
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation;
    searchBloc.getPlacesByQuery(proximity!, query);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
            itemBuilder: (context, i) {
              final place = places[i];
              return ListTile(
                title: Text(place.text),
                subtitle: Text(place.placeName),
                leading: const Icon(
                  Icons.place_outlined,
                  color: Colors.black,
                ),
                onTap: () {
                  print('enviar este lugar $place');
                },
              );
            },
            separatorBuilder: (context, i) => const Divider(),
            itemCount: places.length);
      },
    );
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
