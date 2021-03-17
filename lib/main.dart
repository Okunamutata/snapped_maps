import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapped_maps/business_logic/cubit/image_cubit.dart';
import 'package:snapped_maps/business_logic/cubit/location_cubit.dart';
import 'package:snapped_maps/presentation/views/home_view.dart';

import 'business_logic/router/locator.dart';
import 'business_logic/router/navigation_service.dart';
import 'business_logic/router/router.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LocationCubit>(
          create: (BuildContext context) => LocationCubit()..getPermissions(),
          lazy: false,
        ),
        BlocProvider<ImagePickerCubit>(
          create: (BuildContext context) => ImagePickerCubit(),
          lazy: false,
        ),
      ],
      child: SnappedMapsApp(),
    );
  }
}

class SnappedMapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snapped Maps',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.deepOrange[900],
        highlightColor: Colors.orangeAccent,
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white, centerTitle: true),
        buttonTheme: const ButtonThemeData(shape: ContinuousRectangleBorder()),
        inputDecorationTheme: const InputDecorationTheme(
          helperStyle: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: HomeView.route,
    );
  }
}
