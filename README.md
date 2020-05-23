# yaml_localizations

A minimal [YAML](https://en.wikipedia.org/wiki/YAML) localization package for Flutter.

## Rationale

YAML is a human-readable, configuration file format with a minimal syntax, which allows you to represent [strings](https://yaml-multiline.info/) as key/value pairs. String can be be both unquoted, quoted and span multiple lines. Both basic and literal strings are supported. 

For complex strings, also consider [toml_localizations](https://github.com/erf/toml_localizations), which does not depend on indentation.

For simple strings consider [csv_localizations](https://github.com/erf/csv_localizations), to support all languages in a single document.

## Usage

See [example](example).

### Install

Add to your `pubspec.yaml`

```yaml
dependencies:
  yaml_localizations:
```

### Add a YAML file per language

Add a YAML file per language you support in an asset `path` and describe it in your `pubspec.yaml`

```yaml
flutter:
  assets:
    - {path}/{languageCode}.yaml
```

##### Example YAML file

```yaml
Hi: Hi
Text: |
  There once was a tall man from Ealing
  Who got on a bus to Darjeeling
      It said on the door
      "Please don't sit on the floor"
  So he carefully sat on the ceiling
Long: >
  Wrapped text
  will be folded
  into a single
  paragraph

  Blank lines denote
  paragraph breaks
```

> Tip: Yaml supports several ways of expressing strings. Use the vertical bar character to indicate that a string will span several lines. Use the greater-than character to break up long lines.

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

We keep the API simple, but you can easily add an extension method to `String` like this:

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
