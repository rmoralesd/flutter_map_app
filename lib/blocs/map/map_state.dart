part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;

  final Map<String, Polyline> polylines;

  const MapState(
      {this.isMapInitialized = false,
      this.isFollowingUser = true,
      Map<String, Polyline>? polylines})
      : polylines = polylines ??
            const {}; //Si las polylines se pasan en el constructor, asignelas, sino, inicialice con {} que es un mapa vacio

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    Map<String, Polyline>? polylines,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props => [isMapInitialized, isFollowingUser, polylines];
}
