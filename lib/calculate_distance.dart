import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:sturrd_flutter/date_list/list.dart';

class CalculateDistance {
  void distance(double Lat, double Lng) async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = await Geolocator()
        .distanceBetween(position.latitude, position.longitude, Lat, Lng);
  }
}
