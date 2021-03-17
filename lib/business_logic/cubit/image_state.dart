part of 'image_cubit.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();
}

class ImageInitial extends ImagePickerState {
  @override
  List<Object> get props => [];
}

class ImagePickerNoMorePhotos extends ImagePickerState {
  static const String message = 'Only 6 Images allowed';

  @override
  List<Object> get props => <Object>[message];
}

class ImagePickerPhotosSelected extends ImagePickerState {
  const ImagePickerPhotosSelected({this.photos});

  final List<Image> photos;

  @override
  List<Object> get props => <Object>[photos];
}
