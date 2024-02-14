import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yaml/yaml.dart';

/// Store translations per languageCode/country from a Yaml file used by [YamlLocalizationsDelegate].
class YamlLocalizations {
  /// Map of translations per language code/country key.
  final Map<String, YamlMap> _translations = {};

  /// Path to YAML assets file.
  final String assetPath;

  /// The asset bundle.
  final AssetBundle assetBundle;

  /// A language / country code key used to access translations.
  late String _langTag;

  /// Initialize with asset path to yaml files and an optional assetBundle.
  YamlLocalizations(this.assetPath, [assetBundle])
      : this.assetBundle = assetBundle ?? rootBundle;

  /// Load and cache a yaml file per language / country code.
  Future<YamlLocalizations> load(Locale locale) async {
    // get the key from languageCode and countryCode
    _langTag = locale.toLanguageTag();

    // in cache already
    if (_translations.containsKey(_langTag)) {
      return this;
    }

    // try to load combination of languageCode and countryCode
    try {
      final text = await assetBundle.loadString('$assetPath/$_langTag.yaml');
      _translations[_langTag] = loadYaml(text);
      return this;
    } catch (e) {}

    // try to load only language code
    if (_langTag != locale.languageCode) {
      _langTag = locale.languageCode;
      try {
        final text = await assetBundle.loadString('$assetPath/$_langTag.yaml');
        _translations[_langTag] = loadYaml(text);
        return this;
      } catch (e) {}
    }

    assert(false, 'Translation file not found for code \'$_langTag\'');

    return this;
  }

  /// Get translated String given a [key].
  String string(String key) => _translations[_langTag]![key];

  /// Helper for getting [YamlLocalizations] object.
  static YamlLocalizations? of(BuildContext context) =>
      Localizations.of<YamlLocalizations>(context, YamlLocalizations);
}

/// LocalizationsDelegate that loads translations from a Yaml file.
class YamlLocalizationsDelegate
    extends LocalizationsDelegate<YamlLocalizations> {
  final YamlLocalizations localization;

  YamlLocalizationsDelegate({required String path, AssetBundle? assetBundle})
      : this.localization = YamlLocalizations(path, assetBundle);

  /// We expect all supportedLocales to have asset files for each language.
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<YamlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(YamlLocalizationsDelegate old) => false;
}
