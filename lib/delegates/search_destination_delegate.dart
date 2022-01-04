import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/models/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

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
                  final result = models.SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], place.center[0]),
                    name: place.text,
                    description: place.placeName,
                  );
                  searchBloc.add(OnAddToHistoryEvent(place));
                  close(context, result);
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
    final searchBlocHistory =
        BlocProvider.of<SearchBloc>(context).state.history;
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
        ),
        ...searchBlocHistory
            .map((place) => ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  title: Text(place.placeName),
                  onTap: () {
                    final result = models.SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName,
                    );

                    close(context, result);
                  },
                ))
            .toList(),
      ],
    );
  }
}
