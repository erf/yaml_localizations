import 'package:yaml/yaml.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

/// store translations per languageCode from a Yaml file used by [YamlLocalizationsDelegate]
class YamlLocalizations {
  /// map of translations per languageCode
  final Map<String, YamlMap> _localizedValues = {};

  /// path to Yaml translation asset
  final String assetPath;

  /// supported language codes
  final List<String> supportedLanguageCodes;

  /// language code of current locale, set in [load] method
  String _languageCode;

  /// initialize with asset path to yaml files and a list of supported language codes
  YamlLocalizations({
    this.assetPath,
    this.supportedLanguageCodes,
  });

  /// first time we call load, we read the csv file and initialize translations
  /// next time we just return this
  /// called by [YamlLocalizationsDelegate]
  Future<YamlLocalizations> load(Locale locale) async {
    this._languageCode = locale.languageCode;
    if (_localizedValues.containsKey(_languageCode)) {
      return this;
    }
    final String path = '$assetPath/$_languageCode.yaml';
    final String cvsDoc = await rootBundle.loadString(path);
    final yaml = loadYaml(cvsDoc.trim());
    _localizedValues[_languageCode] = yaml;
    return this;
  }

  /// get translation given a key
  String string(String key) {
    // find translation map given current locale
    final bool containsLocale = _localizedValues.containsKey(_languageCode);
    assert(containsLocale, 'Missing localization for code: $_languageCode');
    final YamlMap translations = _localizedValues[_languageCode];
    // find translated string given translation key
    final bool containsKey = translations.containsKey(key);
    assert(containsKey, 'Missing localization for translation key: $key');
    final String translatedValue = translations[key];
    return translatedValue;
  }

  /// helper for getting [YamlLocalizations] object
  static YamlLocalizations of(BuildContext context) =>
      Localizations.of<YamlLocalizations>(context, YamlLocalizations);

  // helper for getting supported language codes from YamlLocalizationsDelegate
  bool isSupported(Locale locale) => supportedLanguageCodes.contains(locale.languageCode);
}

/// [YamlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class YamlLocalizationsDelegate extends LocalizationsDelegate<YamlLocalizations> {
  final YamlLocalizations localization;

  const YamlLocalizationsDelegate(this.localization);

  @override
  bool isSupported(Locale locale) => localization.isSupported(locale);

  @override
  Future<YamlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(YamlLocalizationsDelegate old) => false;
}
