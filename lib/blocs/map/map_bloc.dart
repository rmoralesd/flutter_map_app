import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/location/location_bloc.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;

  StreamSubscription<LocationState>? locationStream;

  GoogleMapController? _mapController;
  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    locationStream = locationBloc.stream.listen((event) {
      if (!state.isFollowingUser) return;
      if (event.lastKnownLocation == null) return;

      moveCamera(event.lastKnownLocation!);
    });

    on<OnStopFollowingUserMapEvent>((event, emit) {
      //locationStream?.cancel();
      emit(state.copyWith(isFollowingUser: false));
    });

    on<OnStartFollowingUserMapEvent>(_onStartFollowingUser);
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserMapEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }
}
