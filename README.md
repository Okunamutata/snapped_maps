# snapped_maps

A Flutter Application Utilizing Clean Architecture, Bloc State Management, & Google Maps Rest Api

Description: 
The Snapped Maps App reads photos provided from the phone's photo library. 
Image Picking functionality is not implemented.
Currently, the 1st image available is selected. 
The exif data from the selected image is read for GPS data.
The location data is utilize to fetch both the location and approximate address. 

Usage:
The home screen is a google maps view set to view Google Headquarters. 
Pressing the floating action button will fetch the 1st available photo in the phone's gallery. 
It utilizes Bloc state management to handel the UI while the location is loading, completed loading, or has an error. 
When the location is successfully fetched the map will display the location where the photo was taken and title the page with the address of the location.  
This app is built is optimized to run on iOS. 



This project use lint: ^1.0.0
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)


