enum Language {
  farsi,
  english,
}

extension LanguageExtension on Language {
  String get flag {
    return {
      Language.farsi: '🇦🇫',
      Language.english: '🇺🇸',
    }[this]!;
  }

  String get name {
    return {
      Language.farsi: 'فارسی',
      Language.english: 'English',
    }[this]!;
  }

  String get code {
    return {
      Language.farsi: 'fa',
      Language.english: 'en',
    }[this]!;
  }
}
