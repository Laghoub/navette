// To parse this JSON data, do
//
//     final hub = hubFromJson(jsonString);

import 'dart:convert';

Hub hubFromJson(String str) => Hub.fromJson(json.decode(str));

String hubToJson(Hub data) => json.encode(data.toJson());

class Hub {
  Hub({
    this.id,
    this.name,
    this.wilaya,
    this.wilayaId,
    this.commune,
    this.communeId,
    this.adresse,
    this.lat,
    this.lng,
  });

  String id;
  String name;
  String wilaya;
  String wilayaId;
  String commune;
  String communeId;
  String adresse;
  String lat;
  String lng;
  bool selected = true;

  factory Hub.fromJson(Map<String, dynamic> json) => Hub(
    id: json["id"],
    name: json["name"],
    wilaya: json["wilaya"],
    wilayaId: json["wilaya_id"],
    commune: json["commune"],
    communeId: json["commune_id"],
    adresse: json["adresse"],
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "wilaya": wilaya,
    "wilaya_id": wilayaId,
    "commune": commune,
    "commune_id": communeId,
    "adresse": adresse,
    "lat": lat,
    "lng": lng,
  };
}
