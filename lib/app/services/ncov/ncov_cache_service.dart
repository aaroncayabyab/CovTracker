import 'dart:convert';

import 'package:covid_tracker/app/services/ncov/ncov_api_service.dart';
import 'package:covid_tracker/app/services/ncov/ncov_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NCovCacheService {
  NCovCacheService(this.preferences);
  final SharedPreferences preferences;

  NCovModel getData(NCovEndpoint endpoint) {
    try {
      final value = preferences.getInt('${endpoint.toString()}/value');
      final date = preferences.getString('${endpoint.toString()}/date');
      return NCovModel(value: value, date: date);
    } catch (_) {
      return null;
    }
  }

  Future<void> setData(NCovEndpoint endpoint, NCovModel model) async {
    preferences.setInt('${endpoint.toString()}/value', model.value);
    preferences.setString('${endpoint.toString()}/date', model.date);
  }
}
