import 'dart:convert';

import 'package:coronavirus_stats_app/APIData/StatsDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SearchCountry extends StatefulWidget
{
  @override
  _SearchCountryState createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry>
{

  StatsDataProvider countryStats;
  TextEditingController countryController = TextEditingController();
  String countryName;
  bool isSearching = false;

  static const API = 'https://covid19.mathdro.id/api';

  Future<StatsDataProvider> getCountryCoronavirusStats() async
  {
    final result = await http.Client().get(API+'/countries/$countryName').then((value)
    {
      print(value.body);
      countryStats = parsedJson(value.body);

      return countryStats;
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


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('Search Country'),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Image.asset('assets/corona.jpg',
                  width: MediaQuery.of(context).size.width,),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: countryController,
                decoration: InputDecoration(
                    hintText: 'Search Country',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: ()
                      {
                        if(countryController.text.isNotEmpty)
                          {
                            countryName = countryController.text;
                            getCountryCoronavirusStats();
                            setState(()
                            {
                              isSearching = true;
                            });
                          }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellowAccent,width: 1),

                    )

                ),
              ),
            ),

           isSearching == false
           ? Container(margin: EdgeInsets.all(10),height: 275,child: Center(child: Text('Search Any Country'),),)
           : Container(
              child: FutureBuilder(
                future: getCountryCoronavirusStats(),
                builder: (context,snapshot)
                {
                  if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xff041A37)
                          ),
                          margin: EdgeInsets.only(top: 9.2,left: 8,right: 8),
                          padding: EdgeInsets.only(top: 20,left: 40,right: 40,bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Expanded(child: Text(countryName,
                                style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),)),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  Column(
                                    children: <Widget>[

                                      Text('Cases',style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.yellowAccent,fontSize: 18),),
                                      SizedBox(height: 5,),
                                      Text(countryStats.confirmedCases.toString(),style: TextStyle(fontWeight:
                                      FontWeight.bold,color: Colors.yellowAccent,fontSize: 18),),

                                    ],
                                  ),

                                  Column(
                                    children: <Widget>[

                                      Text('Deaths',style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.redAccent,fontSize: 18),),

                                      SizedBox(height: 5,),

                                      Text(countryStats.totalDeaths.toString(),style: TextStyle(fontWeight:
                                      FontWeight.bold,color: Colors.redAccent,fontSize: 18),),

                                    ],
                                  ),

                                  Column(
                                    children: <Widget>[

                                      Text('Recoveries',style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.greenAccent,fontSize: 18),),
                                      SizedBox(height: 5,),
                                      Text(countryStats.totalRecoveries.toString(),style: TextStyle(fontWeight:
                                      FontWeight.bold,color: Colors.greenAccent,fontSize: 18),),

                                    ],
                                  )

                                ],
                              ),

                            ],
                          ),
                        ),
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
