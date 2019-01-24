import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
Future main() async {
  print("hellow");
  List currencies  = await getCurrencies();
  print(currencies);
  runApp(new MaterialApp(home: new Center(
    child : new CryptoListWidget(currencies),
  ),
  )
  );
}
Future<List> getCurrencies() async {
  String apiUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
class CryptoListWidget extends StatelessWidget {
  final List<MaterialColor> _color  = [Colors.blue, Colors.indigo, Colors.red];
  final List _currencies;

  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body : _buildBody(),
      backgroundColor: Colors.blueAccent,
    );
  }
  Widget _buildBody(){
    return new Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      margin: const EdgeInsets.fromLTRB(8.0,56.0,8.0,0.0),
      child: new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget()
        ],
      ),
    );

  }
  Widget _getAppTitleWidget(){
    return new Text(
      'Cryptocurrenices',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.0
      ),
    );
  }
  Widget _getListViewWidget(){
    return new Flexible(
      child : new ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (context, index) {
          final Map currency = _currencies[index];
          // Get the icon color. Since x mod y, will always be less than y,
          // this will be within bounds
          final MaterialColor color = _color[index % _color.length];
          return _getListItemWidget(currency, color);
        },
      )
    );
  }
  CircleAvatar _getLeadingWidget (String currencyName , MaterialColor color ) {
    return new CircleAvatar(
      backgroundColor: color,
      child : new Text (currencyName[0]),
    );

  }
  Text _getTitleWidget(String currencyName ){
    return new Text(
      currencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );


  }
  Text _getSubTitleWidget(String priceUsd , String percentChange1h){
    return new Text('\$$priceUsd\n1 hour: $percentChange1h%');
  }
  ListTile _getListTile(Map currency, MaterialColor color) {
    return new ListTile(
        leading: _getLeadingWidget(currency['name'], color),
        title : _getTitleWidget(currency['name']),
        subtitle: _getSubTitleWidget(currency['price_usd'], currency['percent_change_1h']),
        isThreeLine: true,
    );
  }
  Container _getListItemWidget(Map currency, MaterialColor color) {
    return new Container(
      margin : const EdgeInsets.only(top: 5.0),
      child : new Card(
        child : _getListTile(currency, color)
      )
    );
  }

}
