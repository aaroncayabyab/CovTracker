import 'dart:io';

import 'package:covid_tracker/app/repositories/ncov_repository.dart';
import 'package:covid_tracker/app/services/ncov/ncov_api_service.dart';
import 'package:covid_tracker/app/services/ncov/ncov_model.dart';
import 'package:covid_tracker/app/ui/dashboard_card.dart';
import 'package:covid_tracker/app/ui/last_updated_status.dart';
import 'package:covid_tracker/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<NCovEndpoint, NCovModel> _allData;

  Future<void> _updateData() async {
    try {
      final repository = Provider.of<NCovRepository>(context, listen: false);
      final allData = await repository.getAllData();
      print(allData);
      setState(() {
        _allData = allData;
      });
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final repository = Provider.of<NCovRepository>(context, listen: false);
    final allData = repository.getAllCachedData();
    print(allData);
    setState(() {
      _allData = allData;
    });
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatus(text: _allData.entries.first.value.date),
            for (var data in _allData.entries)
              DashboardCard(endpoint: data?.key, value: data?.value?.value)
          ],
        ),
      ),
    );
  }
}
