

enum Language {
  farsi,
  english,
}

extension LanguageExtension on Language {
  String get flag {
    switch (this) {
      case Language.farsi:
        return '🇦🇫';
      case Language.english:
        return '🇺🇸';
      default:
        return '🇦🇫';
    }
  }

  String get name {
    switch (this) {
      case Language.farsi:
        return 'فارسی';
      case Language.english:
        return 'English';
      default:
        return 'فارسی';
    }
  }

  String get code {
    switch (this) {
      case Language.farsi:
        return 'fa';
      case Language.english:
        return 'en';
      default:
        return 'fa';
    }
  }
}

