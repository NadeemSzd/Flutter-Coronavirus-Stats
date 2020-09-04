
import 'package:http/http.dart' as http;

class StatsDataProvider
{

  String countryName;
  int confirmedCases, totalDeaths, totalRecoveries;

  StatsDataProvider({this.countryName,this.confirmedCases,this.totalDeaths,this.totalRecoveries});

  factory StatsDataProvider.fromJson(Map<String,dynamic> cases,Map<String,dynamic> deaths,Map<String,dynamic> recovered)
  {
    /*print('Yes  it is called ... with  '+ cases['value'].toString() + ' Cases');
    print('Yes  it is called ... with  '+ deaths['value'].toString() + ' Deaths');
    print('Yes  it is called ... with  '+ recovered['value'].toString() + ' Recovered');*/

    return StatsDataProvider(
      confirmedCases: cases['value'],
      totalDeaths: deaths['value'],
      totalRecoveries: recovered['value']
    );
  }

}