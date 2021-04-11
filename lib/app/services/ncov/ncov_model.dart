import 'package:flutter/foundation.dart';

class NCovModel {
  NCovModel({@required this.value, this.date}) : assert(value != null);
  final int value;
  final String date;

  @override
  String toString() => 'value: $value, date: $date';
}
