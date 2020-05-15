import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yaml_localizations/yaml_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        YamlLocalizationsDelegate(
          YamlLocalizations(
            assetPath: 'assets/yaml_translations',
            supportedLanguageCodes: [
              'en',
              'nb',
              'da',
            ],
          ),
        ),
      ],
      supportedLocales: [
        Locale('en'),
        Locale('nb'),
        Locale('da'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('yaml_localizations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              YamlLocalizations.of(context).string('Hi'),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              YamlLocalizations.of(context).string('Text'),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
