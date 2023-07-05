import 'package:flutter/material.dart';

// theme
Color background_primary = const Color(0xFF111015);
Color accent_t = const Color(0xFF34323A);
Color inactive_accent = const Color(0xFF494949);
Color accent_secondary = const Color(0xFF00FFD1);

// strings

ValueNotifier<LanguageType> languageNotifier =
    ValueNotifier<LanguageType>(LanguageType.English);

enum LanguageType {
  English,
  Hindi,
  Tamil,
  Telugu,
  Kannada,
  Malayalam,
}

languageTocode(String language) {
  switch (language) {
    case "English":
      return "en-US";
    case "Hindi":
      return "hi-IN";
    case "Tamil":
      return "ta-IN";
    case "Telugu":
      return "te-IN";
    case "Kannada":
      return "kn-IN";
    case "Malayalam":
      return "ml-IN";
    default:
      return "en-US";
  }
}
