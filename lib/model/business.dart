import "package:built_value/built_value.dart";

part 'business.g.dart';

abstract class Business implements Built<Business, BusinessBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;

  @nullable
  bool get isActive;
  @nullable
  double get latitude;
  @nullable
  double get longitude;

  @nullable
  String get hexColor;

  @nullable
  String get image;
  @nullable
  BusinessType get type;
  @nullable
  String get abbreviation;

  Business._();

  factory Business([void Function(BusinessBuilder) updates]) = _$Business;
}

enum BusinessType { PHARMACY, NORMAL }