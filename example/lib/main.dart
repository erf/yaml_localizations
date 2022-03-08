import 'package:flutter/material.dart';
import 'package:yaml_localizations/yaml_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        YamlLocalizationsDelegate(
            'assets/yaml_translations', DefaultAssetBundle.of(context)),
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('en'),
        Locale('nb'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('yaml_localizations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(YamlLocalizations.of(context)?.string('Hi') ?? ''),
          const SizedBox(height: 12),
          Text(YamlLocalizations.of(context)?.string('Text') ?? ''),
          const SizedBox(height: 12),
          Text(YamlLocalizations.of(context)?.string('Long') ?? ''),
        ],
      ),
    );
  }
}
