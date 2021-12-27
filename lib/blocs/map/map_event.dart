part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitializedEvent(this.controller);
}

class OnStopFollowingUserMapEvent extends MapEvent {}

class OnStartFollowingUserMapEvent extends MapEvent {}

class OnUpdateUserPolylinesEvent extends MapEvent {
  final List<LatLng> userLocations;

  const OnUpdateUserPolylinesEvent(this.userLocations);
}
