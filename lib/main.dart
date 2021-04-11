import 'package:covid_tracker/app/repositories/ncov_repository.dart';
import 'package:covid_tracker/app/services/ncov/ncov_api_service.dart';
import 'package:covid_tracker/app/services/ncov/ncov_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/ui/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(preferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.preferences}) : super(key: key);
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Provider<NCovRepository>(
      create: (_) => NCovRepository(
        apiService: NCovAPIService(),
        cacheService: NCovCacheService(preferences),
      ),
      child: MaterialApp(
        title: 'Covid Tracker',
        theme: ThemeData.dark(),
        home: Dashboard(),
      ),
    );
  }
}
