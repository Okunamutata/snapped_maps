import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:snapped_maps/business_logic/cubit/location_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class HomeView extends StatelessWidget {
  static final String route = '/';
  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    Completer<gm.GoogleMapController> _controller = Completer();

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BlocBuilder<LocationCubit, LocationState>(
            builder: (BuildContext context, LocationState state) {
              if (state is ImagePickerPhotosSelected) {
                return Wrap(
                  children: state.photos
                      .map((File asset) => SizedBox(
                            child: Image.file(asset),
                          ))
                      .toList(),
                );
              } else if (state is LocationLoaded) {
                return BuildFinal(
                    context: context,
                    lat: state.lat,
                    long: state.long,
                    address: state.address,
                    controller: _controller);
              } else if (state is LocationLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return BuildInitial(
                  context: context,
                  controller: _controller,
                  kGooglePlex: gm.CameraPosition(
                    target: gm.LatLng(37.42796133580664, -122.085749655962),
                    zoom: 14.4746,
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class BuildFinal extends StatelessWidget {
  const BuildFinal({
    @required Address address,
    @required double lat,
    @required double long,
    @required BuildContext context,
    @required Completer<gm.GoogleMapController> controller,
  })  : _controller = controller,
        _c = context,
        _lat = lat,
        _long = long,
        _address = address;
  final double _lat;
  final double _long;
  final Address _address;

  final BuildContext _c;
  final Completer<gm.GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snapped Maps',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 800,
              child: Container(
                child: gm.GoogleMap(
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition: gm.CameraPosition(
                      bearing: 192.8334901395799,
                      target: gm.LatLng(_lat, _long),
                      tilt: 59.440717697143555,
                      zoom: 19.151926040649414),
                  mapType: gm.MapType.normal,
                  onMapCreated: (gm.GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 250,
              height: 180,
              child: Center(
                child: Text(
                  _address.addressLine,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<LocationCubit>(_c).goToLocationOfFirstImage();
            },
            elevation: 15.0,
            hoverColor: Colors.blueGrey[900],
            splashColor: Colors.deepOrange[900],
            child: Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildInitial extends StatelessWidget {
  const BuildInitial({
    @required BuildContext context,
    @required gm.CameraPosition kGooglePlex,
    @required Completer<gm.GoogleMapController> controller,
  })  : _kGooglePlex = kGooglePlex,
        _controller = controller,
        _c = context;

  final gm.CameraPosition _kGooglePlex;
  final BuildContext _c;
  final Completer<gm.GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snapped Maps',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        child: gm.GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: gm.MapType.normal,
          onMapCreated: (gm.GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<LocationCubit>(_c).goToLocationOfFirstImage();
            },
            elevation: 15.0,
            hoverColor: Colors.blueGrey[900],
            splashColor: Colors.deepOrange[900],
            child: Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
