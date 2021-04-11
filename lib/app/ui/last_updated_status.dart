import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedStatus extends StatelessWidget {
  LastUpdatedStatus({@required this.text});

  final String text;

  String _lastUpdatedStatusText() {
    try {
      final lastUpdated = DateTime.tryParse(text);
      final formatter = DateFormat.yMd().add_Hms();
      final formatted = formatter.format(lastUpdated);
      return 'Last updated: $formatted';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _lastUpdatedStatusText(),
        textAlign: TextAlign.center,
      ),
    );
  }
}
