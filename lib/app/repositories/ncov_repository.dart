import 'package:covid_tracker/app/services/ncov/ncov_api_service.dart';
import 'package:covid_tracker/app/services/ncov/ncov_cache_service.dart';
import 'package:covid_tracker/app/services/ncov/ncov_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class NCovRepository {
  NCovRepository({@required this.apiService, @required this.cacheService});

  final NCovAPIService apiService;
  final NCovCacheService cacheService;

  String _accessToken;

  Future<NCovModel> _getData(NCovEndpoint endpoint) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      final responseData = await apiService.getData(
          accessToken: _accessToken, endpoint: endpoint);
      await cacheService.setData(endpoint, responseData);
      return responseData;
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        final responseData = await apiService.getData(
            accessToken: _accessToken, endpoint: endpoint);
        await cacheService.setData(endpoint, responseData);
        return responseData;
      }
      rethrow;
    }
  }

  Future<Map<NCovEndpoint, NCovModel>> getAllData() async {
    final allData = await Future.wait([
      _getData(NCovEndpoint.cases),
      _getData(NCovEndpoint.casesSuspected),
      _getData(NCovEndpoint.casesConfirmed),
      _getData(NCovEndpoint.deaths),
      _getData(NCovEndpoint.recovered),
    ]);

    return {
      NCovEndpoint.cases: allData[0],
      NCovEndpoint.casesSuspected: allData[1],
      NCovEndpoint.casesConfirmed: allData[2],
      NCovEndpoint.deaths: allData[3],
      NCovEndpoint.recovered: allData[4],
    };
  }

  Map<NCovEndpoint, NCovModel> getAllCachedData() {
    return {
      NCovEndpoint.cases: cacheService.getData(NCovEndpoint.cases),
      NCovEndpoint.casesSuspected:
          cacheService.getData(NCovEndpoint.casesSuspected),
      NCovEndpoint.casesConfirmed:
          cacheService.getData(NCovEndpoint.casesConfirmed),
      NCovEndpoint.deaths: cacheService.getData(NCovEndpoint.deaths),
      NCovEndpoint.recovered: cacheService.getData(NCovEndpoint.recovered),
    };
  }
}
