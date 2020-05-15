# yaml_localizations

A minimal [YAML](https://en.wikipedia.org/wiki/YAML) localization package for Flutter.

## Usage

See [example](example).

### Install

Add to your `pubspec.yaml`

```yaml
dependencies:
  yaml_localizations:
```

### Add YAML asset file per language

Add a YAML file per language you support in an asset `path` and describe it in your `pubspec.yaml`

```yaml
flutter:
  assets:
    - {path}/{languageCode}.yaml
```

### MaterialApp

Add `YamlLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` using language codes.

```
MaterialApp(
  localizationsDelegates: [
    ... // global delegates
    YamlLocalizationsDelegate(
      YamlLocalizations(
        assetPath: 'yaml_translations',
        supportedLanguageCodes: [ 'en', 'nb', ],
      ),
    ),
  ],
  supportedLocales: [ Locale('en'), Locale('nb'), ],
}

```

### API

Translate strings using

```dart
YamlLocalizations.of(context).string('Hi')
```

We keep the API simple, but you can easily add an extension method `tr` to `String` like this:

```dart
extension LocalizedString on String {
  String tr(BuildContext context) => YamlLocalizations.of(context).string(this);
}
```

### Note on **iOS**

Add supported languages to `ios/Runner/Info.plist` as described 
[here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```
<key>CFBundleLocalizations</key>
<array>
	<string>en</string>
	<string>nb</string>
</array>
```
