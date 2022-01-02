import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/location/location_bloc.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStream;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    locationStream = locationBloc.stream.listen((event) {
      if (event.lastKnownLocation != null) {
        add(OnUpdateUserPolylinesEvent(event.myLocationHistory));
      }
      if (!state.isFollowingUser) return;
      if (event.lastKnownLocation == null) return;

      moveCamera(event.lastKnownLocation!);
    });

    on<OnStopFollowingUserMapEvent>((event, emit) {
      //locationStream?.cancel();
      emit(state.copyWith(isFollowingUser: false));
    });

    on<OnStartFollowingUserMapEvent>(_onStartFollowingUser);

    on<OnUpdateUserPolylinesEvent>(_onPolylinenewPoint);

    on<OnToggleShowUserRouteMapEvent>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    on<OnDisplayPolylinesEvent>((event, emit) {
      emit(state.copyWith(polylines: event.polylines));
    });
  }

  void _onPolylinenewPoint(
      OnUpdateUserPolylinesEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
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

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        width: 5,
        color: Colors.black,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    add(OnDisplayPolylinesEvent(currentPolylines));
  }

  @override
  Future<void> close() {
    locationStream?.cancel();
    return super.close();
  }
}
