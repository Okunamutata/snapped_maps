import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif/flutter_exif.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

part 'image_state.dart';

enum PermissionStatus {
  /// The user granted access to the requested feature.
  granted,

  /// The user denied access to the requested feature.
  denied,

  /// The OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  /// *Only supported on iOS.*
  restricted,

  ///User has authorized this application for limited access.
  /// *Only supported on iOS (iOS14+).*
  limited,

  /// The user denied access to the requested feature and selected to never
  /// again show a request for this permission. The user may still change the
  /// permission status in the settings.
  /// *Only supported on Android.*
  permanentlyDenied,
}

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImageInitial());
  final _pickedImages = <Image>[];
  List<Image> get pickedImages => _pickedImages;
  Map<String, Uint8List> images = Map<String, Uint8List>();
  List<FlutterExifData> items = <FlutterExifData>[];

  final picker = ImagePicker();

  void pickOneImage() async {
    //  bool granted = await _checkPermissions();
    if (true) {
      if (_pickedImages.length == 6) {
        emit(ImagePickerNoMorePhotos());
        emit(ImagePickerPhotosSelected(photos: _pickedImages));
      } else {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        Map<String, IfdTag> imgTags =
            await readExifFromBytes(File(pickedFile.path).readAsBytesSync());
        if (imgTags.containsKey('GPS GPSLongitude')) {
          FlutterExifData item = FlutterExifData(imgTags);
          Uint8List data = await FlutterExif.image(item.identifier);
          items.add(item);
        }
      }
    }
  }

  void pickOneImageFromCamera() async {
    //  bool granted = await _checkPermissions();
    if (true) {
      if (_pickedImages.length == 6) {
        emit(ImagePickerNoMorePhotos());
        emit(ImagePickerPhotosSelected(photos: _pickedImages));
      } else {
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        Map<String, IfdTag> imgTags =
            await readExifFromBytes(File(pickedFile.path).readAsBytesSync());
        if (imgTags.containsKey('GPS GPSLongitude')) {
          FlutterExifData item = FlutterExifData(imgTags);
          Uint8List data = await FlutterExif.image(item.identifier);
          items.add(item);
        }
      }
    }
  }

  Future<bool> _checkPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;
    var galleryStatus = await Permission.photos.status;
    if (cameraStatus.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = (await [
        Permission.camera,
      ].request())
          .cast<Permission, PermissionStatus>();
    }
    if (galleryStatus.isDenied) {
      Map<Permission, PermissionStatus> statuses = (await [
        Permission.photos,
      ].request())
          .cast<Permission, PermissionStatus>();
    }
    if (locationStatus.isDenied) {
      Map<Permission, PermissionStatus> statuses = (await [
        Permission.location,
      ].request())
          .cast<Permission, PermissionStatus>();
    }

    cameraStatus = await Permission.camera.status;
    locationStatus = await Permission.location.status;
    galleryStatus = await Permission.photos.status;

    if (cameraStatus.isGranted &&
        locationStatus.isGranted &&
        galleryStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }
  //
  // Future<bool> _requestPermissions() async {
  //   Map<PermissionGroup, PermissionStatus> permissions =
  //       await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   return (permissions[PermissionGroup.storage] == PermissionStatus.granted);
  // }
}
