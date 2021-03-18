import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:photo_manager/photo_manager.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());
  final List<File> galleryImages = <File>[];
  Map<String, Uint8List> images = Map<String, Uint8List>();
  bool hasPermissions = false;

  Future<void> getPermissions() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
      hasPermissions = true;
    } else {
      // fail
      PhotoManager.openSetting();
    }
  }

  void goToLocationOfFirstImage() async {
    emit(LocationLoading());
    // 1st album in the list, typically the "Recent" or "All" album
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
    // 1st album in the list, typically the "Recent" or "All" album
    AssetPathEntity data = list[(list.length / 2).ceil()];
    List<AssetEntity> imageList = await data.assetList;

    // Grab the 1st image in the available list of photos
    final AssetEntity asset = imageList[0];
    Address address = await _getAddress(asset.latitude, asset.longitude);
    emit(LocationLoaded(
        lat: asset.latitude, long: asset.longitude, address: address));
  }

  Future<Address> _getAddress(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add.first;
  }
}
