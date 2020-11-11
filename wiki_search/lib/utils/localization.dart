import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:wiki_search/l10n/messages_all.dart';

class AppLocalization {
  static Future<AppLocalization> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  String get appTitle {
    return Intl.message('Wiki Search', name: 'appTitle');
  }

  String get httpErrorCode {
    return Intl.message('Error: ', name: 'httpErrorCode');
  }

  String get emptyResults {
    return Intl.message('No results found', name: 'emptyResults');
  }

}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
