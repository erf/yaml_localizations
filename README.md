# yaml_localizations

A minimal [YAML](https://en.wikipedia.org/wiki/YAML) localization package for Flutter.

YAML is a human-readable, configuration file format with a minimal syntax, which allows you to represent [strings](https://yaml-multiline.info/) as key/value pairs in addition to other types. 

YAML is the format used by Flutter's `pubspec.yaml` file.

## Install

Add `yaml_localizations` and `flutter_localizations` as dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  yaml_localizations:
```

### Add a YAML file per language

Add a YAML file per language you support in an asset `path` and describe it in your `pubspec.yaml`

```yaml
flutter:
  assets:
    - assets/yaml_translations/
```

The YAML file name must match the language tag described in `supportedLocales`.

E.g. `Locale('en', 'US')` must have a corresponding `assetPath/en-US.yaml` file.

### Add localizationDelegates and supportedLocales

Add `YamlLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` using language/country codes.

```
MaterialApp(
  localizationsDelegates: [
    // global delegates
    ...GlobalMaterialLocalizations.delegates,
    // yaml localizations
    YamlLocalizationsDelegate('assets/yaml_translations'),
  ],
  supportedLocales: [
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('en'),
    Locale('nb'),
  ],
}

```

### Note on **iOS**

Add supported languages to `ios/Runner/Info.plist` as described 
[here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```
<key>CFBundleLocalizations</key>
<array>
	<string>en-GB</string>
	<string>en</string>
	<string>nb</string>
</array>
```


## YAML format

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

### API

Translate strings using

```dart
YamlLocalizations.of(context)?.string('Hi')
```

We keep the API simple, but you can easily add an extension method to `String` like this:

```dart
extension LocalizedString on String {
  String tr(BuildContext context) => YamlLocalizations.of(context)!.string(this);
}
```


So you can use it like this:

```dart
'Hi'.tr(context)
```

## Example

See [example](example)
