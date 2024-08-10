class PrettierRegExp {
  final bool supportNumbers;
  final bool supportLetters;
  final bool supportWhitespace;
  final bool supportSpecialChars;
  final bool supportArabic;
  final bool caseInsensitive;
  final bool multiLine;
  final bool dotAll;
  final bool includeLookAhead;
  final bool includeLookBehind;
  final String customPattern;
  final bool isEmail;
  final bool isUrl;
  final bool isPhoneNumber;
  final int? minLength;
  final int? maxLength;
  final String? prefix;
  final String? suffix;
  final List<String> mustContain;
  final List<String> mustNotContain;
  final int? exactRepetitions;
  final int? minRepetitions;
  final int? maxRepetitions;
  final bool allowEmptyString;
  final List<String> allowedWords;
  final List<String> disallowedWords;
  final bool isIPv4;
  final bool isIPv6;
  final bool isHexColor;
  final bool isDate;
  final String? dateFormat;
  final bool isTime;
  final String? timeFormat;
  final bool isLatitude;
  final bool isLongitude;
  final bool isCreditCard;
  final List<String> supportedCreditCards;

  PrettierRegExp({
    this.supportNumbers = false,
    this.supportLetters = false,
    this.supportWhitespace = false,
    this.supportSpecialChars = false,
    this.supportArabic = false,
    this.caseInsensitive = false,
    this.multiLine = false,
    this.dotAll = false,
    this.includeLookAhead = false,
    this.includeLookBehind = false,
    this.customPattern = '',
    this.isEmail = false,
    this.isUrl = false,
    this.isPhoneNumber = false,
    this.minLength,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.mustContain = const [],
    this.mustNotContain = const [],
    this.exactRepetitions,
    this.minRepetitions,
    this.maxRepetitions,
    this.allowEmptyString = false,
    this.allowedWords = const [],
    this.disallowedWords = const [],
    this.isIPv4 = false,
    this.isIPv6 = false,
    this.isHexColor = false,
    this.isDate = false,
    this.dateFormat,
    this.isTime = false,
    this.timeFormat,
    this.isLatitude = false,
    this.isLongitude = false,
    this.isCreditCard = false,
    this.supportedCreditCards = const [],
  });
  RegExp generate() {
    try {
      if (isEmail) return _emailRegExp();
      if (isUrl) return _urlRegExp();
      if (isPhoneNumber) return _phoneRegExp();
      if (isIPv4) return _ipv4RegExp();
      if (isIPv6) return _ipv6RegExp();
      if (isHexColor) return _hexColorRegExp();
      if (isDate) return _dateRegExp();
      if (isTime) return _timeRegExp();
      if (isLatitude) return _latitudeRegExp();
      if (isLongitude) return _longitudeRegExp();
      if (isCreditCard) return _creditCardRegExp();

      String pattern = _buildBasePattern();
      pattern = _applyLookarounds(pattern);
      pattern = _applyRepetitions(pattern);
      pattern = _applyLengthConstraints(pattern);
      pattern = _applyPrefixSuffix(pattern);
      pattern = _applyWordConstraints(pattern);
      pattern = _applyCustomPattern(pattern);

      pattern = '^' + pattern + r'$';
      print(pattern);
      return RegExp(
        pattern,
        caseSensitive: !caseInsensitive,
        multiLine: multiLine,
        dotAll: dotAll,
        unicode: true,
      );
    } catch (e) {
      throw Exception('Error generating regular expression: $e');
    }
  }

  String _buildBasePattern() {
    final List<String> patterns = [];
    if (supportNumbers) patterns.add(r'\d');
    if (supportLetters) patterns.add('a-zA-Z');
    if (supportWhitespace) patterns.add(r'\s');
    if (supportSpecialChars) {
      patterns.add(r'!@#$%^&*()_+\-=\[\]{};:"\\|,.<>?/~');
    }
    if (supportArabic) {
      patterns.add(
          r'\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF');
    }

    return patterns.isNotEmpty ? '[${patterns.join()}]+' : '';
  }

  String _applyLengthConstraints(String pattern) {
    if (minLength != null && maxLength != null) {
      // Apply exact length constraints
      return '^.{${minLength},$maxLength}' r'$' '';
    } else if (minLength != null) {
      // Apply minimum length constraint
      return '^.{$minLength,}' r'$' '';
    } else if (maxLength != null) {
      // Apply maximum length constraint
      return '^.{0,$maxLength}' r'$' '';
    }
    return pattern; // No length constraints
  }

  String _applyRepetitions(String pattern) {
    if (exactRepetitions != null) {
      return '(?:$pattern){$exactRepetitions}';
    } else if (minRepetitions != null || maxRepetitions != null) {
      return '(?:$pattern){${minRepetitions ?? ''}${minRepetitions != null && maxRepetitions != null ? ',' : ''}${maxRepetitions ?? ''}}';
    } else {
      return pattern;
    }
  }

  String _applyPrefixSuffix(String pattern) {
    if (prefix != null) pattern = RegExp.escape(prefix!) + pattern;
    if (suffix != null) pattern = pattern + RegExp.escape(suffix!);
    return pattern;
  }

  String _applyLookarounds(String pattern) {
    String lookaheads = '';

    // Positive lookaheads for mustContain
    if (mustContain.isNotEmpty) {
      for (final contain in mustContain) {
        lookaheads += '(?=.*${RegExp.escape(contain)})';
      }
    }

    // Negative lookaheads for mustNotContain
    if (mustNotContain.isNotEmpty) {
      for (final notContain in mustNotContain) {
        lookaheads += '(?!.*${RegExp.escape(notContain)})';
      }
    }

    // Apply lookaheads and append base pattern
    return lookaheads + (pattern.isNotEmpty ? pattern : '.*');
  }

  String _applyWordConstraints(String pattern) {
    if (allowedWords.isNotEmpty) {
      final allowedPattern = allowedWords.map(RegExp.escape).join('|');
      pattern = '(?:${allowedPattern})';
    }
    if (disallowedWords.isNotEmpty) {
      pattern =
          '(?!.*(?:${disallowedWords.map(RegExp.escape).join('|')})).*$pattern';
    }
    return pattern;
  }

  String _applyCustomPattern(String pattern) {
    return customPattern.isNotEmpty ? customPattern : pattern;
  }

  RegExp _emailRegExp() {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _urlRegExp() {
    return RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _phoneRegExp() {
    return RegExp(
      r'^\+?[1-9]\d{1,14}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _ipv4RegExp() {
    return RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _ipv6RegExp() {
    return RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){1,6}|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|::(ffff(:0{1,4}){0,1}:){0,1}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,3}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,2}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,1}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,1}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,2}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,3}:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _hexColorRegExp() {
    return RegExp(
      r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _dateRegExp() {
    final pattern = dateFormat != null
        ? _convertDateFormatToRegex(dateFormat!)
        : r'^\d{4}-\d{2}-\d{2}$';
    return RegExp(
      pattern,
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _timeRegExp() {
    final pattern = timeFormat != null
        ? _convertTimeFormatToRegex(timeFormat!)
        : r'^\d{2}:\d{2}:\d{2}$';
    return RegExp(
      pattern,
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _latitudeRegExp() {
    return RegExp(
      r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _longitudeRegExp() {
    return RegExp(
      r'^[-+]?((1[0-7]\d|[1-9]\d?)\.\d+|180(\.0+)?)$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  RegExp _creditCardRegExp() {
    final supportedPatterns = {
      'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
      'mastercard': r'^5[1-5][0-9]{14}$',
      'amex': r'^3[47][0-9]{13}$',
      'discover': r'^6(?:011|5[0-9]{2})[0-9]{12}$',
      'jcb': r'^(?:2131|1800|35\d{3})\d{11}$',
      'dinersclub': r'^3(?:0[0-5]|[68][0-9])\d{11}$',
      'enroute': r'^2(014|149)\d{11}$',
      'unionpay': r'^62[0-9]{14,17}$',
    };

    if (supportedCreditCards.isEmpty) {
      return RegExp(
        supportedPatterns.values.join('|'),
        caseSensitive: !caseInsensitive,
        multiLine: multiLine,
        dotAll: dotAll,
        unicode: true,
      );
    } else {
      final patterns = supportedCreditCards
          .where((card) => supportedPatterns.containsKey(card))
          .map((card) => supportedPatterns[card]!)
          .join('|');
      return RegExp(
        patterns,
        caseSensitive: !caseInsensitive,
        multiLine: multiLine,
        dotAll: dotAll,
        unicode: true,
      );
    }
  }

  String _getCreditCardPattern(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return r'^4[0-9]{12}(?:[0-9]{3})?$';
      case 'mastercard':
        return r'^5[1-5][0-9]{14}$';
      case 'amex':
        return r'^3[47][0-9]{13}$';
      case 'discover':
        return r'^6(?:011|5[0-9]{2})[0-9]{12}$';
      default:
        return r'^\d{13,19}$';
    }
  }

  String _convertTimeFormatToRegex(String format) {
    return format
        .replaceAll('HH', r'(?:[01]\d|2[0-3])') // Hours in 24-hour format
        .replaceAll('mm', r'[0-5]\d') // Minutes
        .replaceAll('ss', r'[0-5]\d'); // Seconds
  }

  String _convertDateFormatToRegex(String format) {
    return format
        .replaceAll('YYYY', r'\d{4}') // Year
        .replaceAll('MM', r'(?:0[1-9]|1[0-2])') // Month
        .replaceAll('DD', r'(?:0[1-9]|[12]\d|3[01])'); // Day
  }
}
