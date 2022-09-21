import 'package:lpinyin/lpinyin.dart';

class SearchUtil {
  const SearchUtil._();

  static final Map<String, String> _zhPinyin = {};

  static String? getCN(String? words) {
    if (words == null) return null;
    return _zhPinyin[words] ??= {
      PinyinHelper.getPinyinE(words).replaceAll(' ', ''),
      PinyinHelper.getShortPinyin(words),
      words.replaceAll(' ', '').toLowerCase(),
      words,
    }.join('\t');
  }

  static String getSortAlphabet(String words) {
    return getCN(words)!.toLowerCase();
  }
}
