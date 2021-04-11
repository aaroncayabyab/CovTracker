import 'dart:convert';

import 'package:covid_tracker/app/services/api_keys.dart';
import 'package:covid_tracker/app/services/ncov/ncov_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum NCovEndpoint {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

class NCovAPIService {
  static final String host = 'ncov2019-admin.firebaseapp.com';

  Future<NCovModel> getData(
      {@required String accessToken, @required NCovEndpoint endpoint}) async {
    final response = await http.get(_endpointURI(_paths[endpoint]),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)[0];
      final responseJsonKey = _responseJsonKeys[endpoint];
      final value = data[responseJsonKey];
      if (value != null) {
        return NCovModel(value: value, date: data['date']);
      }
    }
    throw response;
  }

  Future<String> getAccessToken() async {
    final response = await http.post(_endpointURI('token'),
        headers: {'Authorization': 'Basic ${APIKeys.ncovSandboxKey}'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    throw response;
  }

  Uri _endpointURI(String endpoint) {
    return Uri(scheme: 'https', host: host, path: endpoint);
  }

  static Map<NCovEndpoint, String> _paths = {
    NCovEndpoint.cases: 'cases',
    NCovEndpoint.casesSuspected: 'casesSuspected',
    NCovEndpoint.casesConfirmed: 'casesConfirmed',
    NCovEndpoint.deaths: 'deaths',
    NCovEndpoint.recovered: 'recovered',
  };

  static Map<NCovEndpoint, String> _responseJsonKeys = {
    NCovEndpoint.cases: 'cases',
    NCovEndpoint.casesSuspected: 'data',
    NCovEndpoint.casesConfirmed: 'data',
    NCovEndpoint.deaths: 'data',
    NCovEndpoint.recovered: 'data',
  };
}
