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
              'en-US',
              'en-GB',
              'nb',
            ],
          ),
        ),
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('en', 'GB'),
        Locale('en'),
        Locale('nb'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(YamlLocalizations.of(context).string('Hi')),
          SizedBox(height: 12),
          Text(YamlLocalizations.of(context).string('Text')),
          SizedBox(height: 12),
          Text(YamlLocalizations.of(context).string('Long')),
        ],
      ),
    );
  }
}
