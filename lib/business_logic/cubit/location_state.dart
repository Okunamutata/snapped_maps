part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationLoading extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationLoaded extends LocationState {
  const LocationLoaded({this.lat, this.long, this.address});
  final double lat;
  final double long;
  final Address address;

  @override
  List<Object> get props => [lat, long, address];
}

class ImagePickerNoMorePhotos extends LocationState {
  static const String message = 'Only 6 Images allowed';

  @override
  List<Object> get props => <Object>[message];
}

class ImagePickerPhotosSelected extends LocationState {
  const ImagePickerPhotosSelected({this.photos});

  final List<File> photos;

  @override
  List<Object> get props => <Object>[photos];
}
