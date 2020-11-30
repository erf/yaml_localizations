import 'package:yaml/yaml.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

/// store translations per languageCode/country from a Yaml file used by [YamlLocalizationsDelegate]
class YamlLocalizations {
  /// map of translations per language/country code hash
  final Map<String, YamlMap> _translationMap = {};

  /// path to translation assets
  final String assetPath;

  /// a hash key of language / country code used for [_translationsMap]
  String _codeKey;

  /// initialize with asset path to yaml files and a list of supported language codes
  YamlLocalizations(this.assetPath);

  Future<String> loadAsset(path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {}
    return null;
  }

  /// load and cache a yaml file per language / country code
  Future<YamlLocalizations> load(Locale locale) async {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    assert(languageCode != null);
    assert(languageCode.isNotEmpty);

    if (countryCode != null && countryCode.isNotEmpty) {
      _codeKey = '$languageCode-$countryCode';
    } else {
      _codeKey = '$languageCode';
    }

    debugPrint('codeKey $_codeKey');

    // in cache
    if (_translationMap.containsKey(_codeKey)) {
      return this;
    }

    debugPrint('load $_codeKey');

    // try to load with with _codeKey
    // could be a combination of language / country code
    final text = await loadAsset('$assetPath/$_codeKey.yaml');
    if (text != null) {
      _translationMap[_codeKey] = loadYaml(text);
      return this;
    }

    // if it was a combined key, try to load with only language code
    if (_codeKey != languageCode) {
      _codeKey = languageCode;
      debugPrint('load $_codeKey');
      final text = await loadAsset('$assetPath/$_codeKey.yaml');
      // asset file should always exist for a supportedLanguageCode
      assert(text != null);
      _translationMap[_codeKey] = loadYaml(text);
    }

    assert(false, 'translation file not found for code \'$_codeKey\'');

    return this;
  }

  /// get translation given a key
  String string(String key) {
    final containsLocale = _translationMap.containsKey(_codeKey);
    assert(containsLocale, 'Missing translation for code: $_codeKey');
    final translations = _translationMap[_codeKey];
    final containsKey = translations.containsKey(key);
    assert(containsKey, 'Missing localization for key: $key');
    final translatedValue = translations[key];
    return translatedValue;
  }

  /// helper for getting [YamlLocalizations] object
  static YamlLocalizations of(BuildContext context) =>
      Localizations.of<YamlLocalizations>(context, YamlLocalizations);
}

/// [YamlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class YamlLocalizationsDelegate
    extends LocalizationsDelegate<YamlLocalizations> {
  final YamlLocalizations localization;

  YamlLocalizationsDelegate(String path)
      : this.localization = YamlLocalizations(path);

  /// we expect all supportedLocales to have asset files
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<YamlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(YamlLocalizationsDelegate old) => false;
}
