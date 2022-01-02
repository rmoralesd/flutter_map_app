import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maps_app/services/service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });

    on<OnDiactivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: false));
    });
  }

  Future getCoorsStartToEnd(LatLng start, LatLng end) async {
    final resp = await trafficService.getCoordsStartToEnd(start, end);
  }
}
