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

class OnToggleShowUserRouteMapEvent extends MapEvent {}

class OnDisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const OnDisplayPolylinesEvent(this.polylines, this.markers);
}
