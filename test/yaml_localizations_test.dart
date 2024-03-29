import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yaml_localizations/yaml_localizations.dart';

/// https://flutter.dev/docs/testing
/// https://flutter.dev/docs/cookbook/testing/unit/introduction
/// https://flutter.dev/docs/cookbook/testing/widget/introduction
/// https://stackoverflow.com/questions/49480080/flutter-load-assets-for-tests
/// https://api.flutter.dev/flutter/widgets/DefaultAssetBundle-class.html
/// https://stackoverflow.com/questions/52463714/how-to-test-localized-widgets-in-flutter
/// https://dart.dev/null-safety/migration-guide

ByteData toByteData(String text) {
  return ByteData.view(Uint8List.fromList(utf8.encode(text)).buffer);
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('en.yaml')) {
      return toByteData('Hi: Hi en');
    } else if (key.endsWith('en-US.yaml')) {
      return toByteData('Hi: Hi en-US');
    } else if (key.endsWith('nb.yaml')) {
      return toByteData('Hi: Hei nb');
    } else if (key.endsWith('nb-NO.yaml')) {
      return toByteData('Hi: Hei nb-NO');
    } else {
      return toByteData('Error');
    }
  }
}

Widget buildTestWidgetWithLocale(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: [
      YamlLocalizationsDelegate(
        path: 'assets/yaml_translations',
        assetBundle: TestAssetBundle(),
      ),
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: [
      Locale('en'),
      Locale('en', 'US'),
      Locale('nb'),
      Locale('nb', 'NO'),
    ],
    home: Scaffold(
      body: Builder(
        builder: (context) =>
            Text(YamlLocalizations.of(context)?.string('Hi') ?? ''),
      ),
    ),
  );
}

void main() {
  testWidgets('MyTestApp find [en] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('en')));
    await tester.pump();
    final hiFinder = find.text('Hi en');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [en-US] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('en', 'US')));
    await tester.pump();
    final hiFinder = find.text('Hi en-US');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [nb] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('nb')));
    await tester.pump();
    final hiFinder = find.text('Hei nb');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [nb-NO] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('nb', 'NO')));
    await tester.pump();
    final hiFinder = find.text('Hei nb-NO');
    expect(hiFinder, findsOneWidget);
  });

  test('Locale get codeKey from languageCode', () {
    expect(const Locale('en').toLanguageTag(), 'en');
    expect(const Locale('nb').toLanguageTag(), 'nb');
  });

  test('Locale get codeKey from languageCode and country', () {
    expect(const Locale('en', 'US').toLanguageTag(), 'en-US');
    expect(const Locale('en', 'GB').toLanguageTag(), 'en-GB');
  });
}
