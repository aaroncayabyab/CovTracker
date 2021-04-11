import 'package:covid_tracker/app/services/ncov/ncov_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardData {
  final String title;
  final String assetName;
  final Color color;

  CardData(this.title, this.assetName, this.color);
}

class DashboardCard extends StatelessWidget {
  final NCovEndpoint endpoint;
  final int value;

  const DashboardCard({Key key, this.endpoint, this.value}) : super(key: key);

  static Map<NCovEndpoint, CardData> _cards = {
    NCovEndpoint.cases:
        CardData('Cases', 'assets/images/count.png', Color(0xFFFFF492)),
    NCovEndpoint.casesSuspected: CardData(
        'Suspected cases', 'assets/images/suspect.png', Color(0xFFEEDA28)),
    NCovEndpoint.casesConfirmed: CardData(
        'Confirmed cases', 'assets/images/fever.png', Color(0xFFE99600)),
    NCovEndpoint.deaths:
        CardData('Deaths', 'assets/images/death.png', Color(0xFFE40000)),
    NCovEndpoint.recovered:
        CardData('Recovered', 'assets/images/patient.png', Color(0xFF70A901)),
  };

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cards[endpoint];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardData.title,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: cardData.color,
                      ),
                ),
                SizedBox(height: 4.0),
                SizedBox(
                    height: 52.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          cardData.assetName,
                          color: cardData.color,
                        ),
                        Text(
                          formattedValue,
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              color: cardData.color,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
