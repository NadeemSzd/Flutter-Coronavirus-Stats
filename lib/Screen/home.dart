import 'dart:convert';

import 'package:coronavirus_stats_app/APIData/StatsDataProvider.dart';
import 'package:coronavirus_stats_app/Screen/searchCountry.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{

  StatsDataProvider worldStats;
  StatsDataProvider countryStats;

  List<StatsDataProvider> countryList = [];
  List<String> countries = ['Pakistan','China','Turkey','Iran','Russia','Italy','Spain','India','Germany','Australia'];

  static const API = 'https://covid19.mathdro.id/api';

  Future<StatsDataProvider> getCountryCoronavirusStats(String countryName) async
  {

    final result = await http.Client().get(API+'/countries/$countryName').then((value)
    {

      print(value.body);

      /* print('************** Data Present **************');

      final jsonDecoded = json.decode(value.body);

      final jsonCases = jsonDecoded['confirmed'];
      final jsonDeaths = jsonDecoded['deaths'];
      final jsonRecovered = jsonDecoded['recovered'];

      Map<String,dynamic> cases = jsonCases;

      print('Pakistan Total Cases ----> '+ cases['value'].toString());
      print('********** END ***********');*/

      countryStats = parsedJson(value.body);
      countryStats.countryName = countryName;

      // print('Wow  .... with '+ worldStats.confirmedCases.toString() + ' Cases');
      countryList.add(countryStats);

      return countryStats;
    });

  }

  Future<StatsDataProvider> getCoronavirusStats() async
  {

    final result = await http.Client().get(API).then((value)
    {

      print(value.body);
      /* print('************** Data Present **************');
       final jsonDecoded = json.decode(value.body);
       final jsonCases = jsonDecoded['confirmed'];
      final jsonDeaths = jsonDecoded['deaths'];
      final jsonRecovered = jsonDecoded['recovered'];

      Map<String,dynamic> cases = jsonCases;

      print('Pakistan Total Cases ----> '+ cases['value'].toString());
      print('********** END ***********');*/
      worldStats = parsedJson(value.body);
      //  print('Wow  .... with '+ worldStats.confirmedCases.toString() + ' Cases');
      return worldStats;
    });

  }


  StatsDataProvider parsedJson(final response)
  {
    final jsonDecoded = json.decode(response);
    final jsonCases = jsonDecoded['confirmed'];
    final jsonDeaths = jsonDecoded['deaths'];
    final jsonRecovered = jsonDecoded['recovered'];

    return StatsDataProvider.fromJson(jsonCases,jsonDeaths,jsonRecovered);
  }

  Future<StatsDataProvider> getCountriesStats() async
  {

    for(var country in countries)
    {
      StatsDataProvider model = await getCountryCoronavirusStats(country);
    }

  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('Covid-19 Stats'),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchCountry()));
        },
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              child: FutureBuilder(
                future: getCoronavirusStats(),
                builder: (context,snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xff041A37),
                            ),
                            margin: EdgeInsets.only(top: 9.2,left: 8,right: 8),
                            child: Stack(
                              children: <Widget>[

                                Image.asset('assets/corona.jpg',
                                  width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Container(
                                      child: Text('World Wide Covid-19 Stats',
                                        style: TextStyle(fontSize: 21,color: Colors.white,fontWeight: FontWeight.bold),),
                                      padding: EdgeInsets.only(top: 15,left: 20),
                                    ),

                                    SizedBox(height: 30,),

                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Column(
                                        children: <Widget>[

                                          Column(
                                            children: <Widget>[

                                              Text('Cases',style: TextStyle(
                                                  fontWeight: FontWeight.bold,color: Colors.yellowAccent,fontSize: 18),),
                                              SizedBox(height: 5,),
                                              Text(worldStats.confirmedCases.toString(),style: TextStyle(fontWeight:
                                              FontWeight.bold,color: Colors.yellowAccent,fontSize: 18),),

                                            ],
                                          ),

                                          SizedBox(height: 20,),

                                          Column(
                                            children: <Widget>[

                                              Text('Deaths',style: TextStyle(
                                                  fontWeight: FontWeight.bold,color: Colors.redAccent,fontSize: 18),),

                                              SizedBox(height: 5,),

                                              Text(worldStats.totalDeaths.toString(),style: TextStyle(fontWeight:
                                              FontWeight.bold,color: Colors.redAccent,fontSize: 18),),

                                            ],
                                          ),

                                          SizedBox(height: 20,),

                                          Column(
                                            children: <Widget>[

                                              Text('Recovered',style: TextStyle(
                                                  fontWeight: FontWeight.bold,color: Colors.greenAccent,fontSize: 18),),
                                              SizedBox(height: 5,),
                                              Text(worldStats.totalRecoveries.toString(),style: TextStyle(fontWeight:
                                              FontWeight.bold,color: Colors.greenAccent,fontSize: 18),),

                                            ],
                                          )

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 5,),

            Container(
             // color: Colors.purple,
              height: MediaQuery.of(context).size.height * 0.75,
              child: FutureBuilder(
                future: getCountriesStats(),
                builder: (context,snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(child: CircularProgressIndicator());
                    }
                  return ListView.builder(
                    itemBuilder: (context,index)
                    {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff041A37)
                        ),
                        margin: EdgeInsets.only(top: 9.2,left: 8,right: 8),
                        padding: EdgeInsets.only(top: 10,left: 10,right: 15,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Expanded(child: Text(countryList[index].countryName,style: TextStyle(fontSize: 20,color: Colors.white),)),

                            Column(
                              children: <Widget>
                              [
                                Text('Cases',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent),),
                                SizedBox(height: 5,),
                                Text(countryList[index].confirmedCases.toString(),style: TextStyle(fontWeight:
                                FontWeight.bold,color: Colors.yellowAccent),),
                              ],
                            ),

                            SizedBox(width: 30,),

                            Column(
                              children: <Widget>
                              [
                                Text('Deaths',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),),

                                SizedBox(height: 5,),

                                Text(countryList[index].totalDeaths.toString(),style: TextStyle(fontWeight:
                                FontWeight.bold,color: Colors.redAccent),),
                              ],
                            ),

                            SizedBox(width: 30,),

                            Column(
                              children: <Widget>
                              [
                                Text('Recovered',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.greenAccent),),
                                SizedBox(height: 5,),
                                Text(countryList[index].totalRecoveries.toString(),style: TextStyle(fontWeight:
                                FontWeight.bold,color: Colors.greenAccent),),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                    itemCount: countryList.length,
                  );
                },
              ),
            ),

          ],
        ),
      ),

    );
  }
}
