import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

enum Coins { BTC, ETH, LTH }

class _PriceScreenState extends State<PriceScreen> {
  int brate;
  int erate;
  String selectedCurrency = 'USD';

  CupertinoPicker iosMenu() {
    List<Text> pickerItemlist = [];
    for (String currency in currenciesList) {
      pickerItemlist.add(Text(currency));
    }
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: pickerItemlist);
  }

  DropdownButton<String> androidMenu() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() async {
            selectedCurrency = value;
            await check();
          });
        });
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return androidMenu();
    } else if (Platform.isIOS) {
      return iosMenu();
    }
  }

  Future<void> check() async {
    Networking net = new Networking();

    var data =
        await net.getExchangeRate(currency: selectedCurrency, coin: "BTC");
    print(data);
    var data2 =
        await net.getExchangeRate(currency: selectedCurrency, coin: "ETH");
    double Brate = jsonDecode(data)["rate"];
    double Erate = jsonDecode(data2)["rate"];
    brate = Brate.toInt();
    erate = Erate.toInt();
    setState(() {
      this.erate = erate;
      this.brate = brate;
      selectedCurrency = this.selectedCurrency;
    });
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    check();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 BTC =$brate $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ETH =$erate $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
