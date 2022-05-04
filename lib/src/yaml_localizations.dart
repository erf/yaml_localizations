import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yaml/yaml.dart';

/// store translations per languageCode/country from a Yaml file used by [YamlLocalizationsDelegate]
class YamlLocalizations {
  /// map of translations per language/country code hash
  final Map<String, YamlMap> _translations = {};

  /// path to translation assets
  final String assetPath;

  /// the asset bundle
  final AssetBundle assetBundle;

  /// a hash key of language / country code used for [_translationsMap]
  late String _codeKey;

  /// initialize with asset path to yaml files and an optional assetBundle
  YamlLocalizations(this.assetPath, [assetBundle])
      : this.assetBundle = assetBundle ?? rootBundle;

  /// load and cache a yaml file per language / country code
  Future<YamlLocalizations> load(Locale locale) async {
    // get the key from languageCode and countryCode
    _codeKey = locale.toLanguageTag();

    // in cache already
    if (_translations.containsKey(_codeKey)) {
      return this;
    }

    // try to load combination of languageCode and countryCode
    try {
      final text = await assetBundle.loadString('$assetPath/$_codeKey.yaml');
      _translations[_codeKey] = loadYaml(text);
      return this;
    } catch (e) {}

    // try to load only language code
    if (_codeKey != locale.languageCode) {
      _codeKey = locale.languageCode;
      try {
        final text = await assetBundle.loadString('$assetPath/$_codeKey.yaml');
        _translations[_codeKey] = loadYaml(text);
        return this;
      } catch (e) {}
    }

    assert(false, 'Translation file not found for code \'$_codeKey\'');

    return this;
  }

  /// get translation given a key
  String string(String key) {
    final containsLocale = _translations.containsKey(_codeKey);
    assert(containsLocale, 'Missing translation for code: $_codeKey');
    final map = _translations[_codeKey]!;
    final containsKey = map.containsKey(key);
    assert(containsKey, 'Missing localization for key: $key');
    final translatedValue = map[key];
    return translatedValue;
  }

  /// helper for getting [YamlLocalizations] object
  static YamlLocalizations? of(BuildContext context) =>
      Localizations.of<YamlLocalizations>(context, YamlLocalizations);
}

/// [YamlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class YamlLocalizationsDelegate
    extends LocalizationsDelegate<YamlLocalizations> {
  final YamlLocalizations localization;

  YamlLocalizationsDelegate(String path, [AssetBundle? assetBundle])
      : this.localization = YamlLocalizations(path, assetBundle);

  /// we expect all supportedLocales to have asset files
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<YamlLocalizations> load(Locale locale) {
    return localization.load(locale);
  }

  @override
  bool shouldReload(YamlLocalizationsDelegate old) => false;
}
