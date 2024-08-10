/// A class for generating customized regular expressions with various options.
///
/// This class provides a flexible way to create regular expressions for different
/// use cases, including validating emails, URLs, phone numbers, and more.
class PrettierRegExp {
  /// Whether to include numeric characters in the pattern.
  final bool supportNumbers;

  /// Whether to include alphabetic characters in the pattern.
  final bool supportLetters;

  /// Whether to include whitespace characters in the pattern.
  final bool supportWhitespace;

  /// Whether to include special characters in the pattern.
  final bool supportSpecialChars;

  /// Whether to include Arabic characters in the pattern.
  final bool supportArabic;

  /// Whether the pattern should be case-insensitive.
  final bool caseInsensitive;

  /// Whether to enable multi-line mode for the pattern.
  final bool multiLine;

  /// Whether to allow '.' to match newline characters.
  final bool dotAll;

  /// Whether to include positive lookahead assertions.
  final bool includeLookAhead;

  /// Whether to include positive lookbehind assertions.
  final bool includeLookBehind;

  /// A custom pattern to be used instead of the generated one.
  final String customPattern;

  /// Whether to generate an email validation pattern.
  final bool isEmail;

  /// Whether to generate a URL validation pattern.
  final bool isUrl;

  /// Whether to generate a phone number validation pattern.
  final bool isPhoneNumber;

  /// The minimum length of the matched string.
  final int? minLength;

  /// The maximum length of the matched string.
  final int? maxLength;

  /// A string that must appear at the start of the match.
  final String? prefix;

  /// A string that must appear at the end of the match.
  final String? suffix;

  /// A list of strings that must be present in the match.
  final List<String> mustContain;

  /// A list of strings that must not be present in the match.
  final List<String> mustNotContain;

  /// The exact number of times the pattern should repeat.
  final int? exactRepetitions;

  /// The minimum number of times the pattern should repeat.
  final int? minRepetitions;

  /// The maximum number of times the pattern should repeat.
  final int? maxRepetitions;

  /// Whether to allow an empty string to match.
  final bool allowEmptyString;

  /// A list of words that are allowed to match.
  final List<String> allowedWords;

  /// A list of words that are not allowed to match.
  final List<String> disallowedWords;

  /// Whether to generate an IPv4 address validation pattern.
  final bool isIPv4;

  /// Whether to generate an IPv6 address validation pattern.
  final bool isIPv6;

  /// Whether to generate a hexadecimal color code validation pattern.
  final bool isHexColor;

  /// Whether to generate a date validation pattern.
  final bool isDate;

  /// The format string for date validation (e.g., "YYYY-MM-DD").
  final String? dateFormat;

  /// Whether to generate a time validation pattern.
  final bool isTime;

  /// The format string for time validation (e.g., "HH:mm:ss").
  final String? timeFormat;

  /// Whether to generate a latitude validation pattern.
  final bool isLatitude;

  /// Whether to generate a longitude validation pattern.
  final bool isLongitude;

  /// Whether to generate a credit card number validation pattern.
  final bool isCreditCard;

  /// A list of supported credit card types for validation.
  final List<String> supportedCreditCards;

  /// Creates a new instance of PrettierRegExp with the specified options.
  ///
  /// All boolean parameters default to false, and all list parameters default to empty lists.
  /// Numeric parameters (minLength, maxLength, exactRepetitions, minRepetitions, maxRepetitions)
  /// default to null, meaning no constraint is applied.
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

  /// Generates a RegExp object based on the configured options.
  ///
  /// Returns:
  /// A [RegExp] object that can be used for pattern matching.
  ///
  /// Throws:
  /// An [Exception] if there's an error generating the regular expression.
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

  /// Builds the base pattern based on the supported character types.
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

  /// Applies length constraints to the pattern.
  String _applyLengthConstraints(String pattern) {
    if (minLength != null && maxLength != null) {
      return '^.{$minLength,$maxLength}' r'$' '';
    } else if (minLength != null) {
      return '^.{$minLength,}' r'$' '';
    } else if (maxLength != null) {
      return '^.{0,$maxLength}' r'$' '';
    }
    return pattern;
  }

  /// Applies repetition constraints to the pattern.
  String _applyRepetitions(String pattern) {
    if (exactRepetitions != null) {
      return '(?:$pattern){$exactRepetitions}';
    } else if (minRepetitions != null || maxRepetitions != null) {
      return '(?:$pattern){${minRepetitions ?? ''}${minRepetitions != null && maxRepetitions != null ? ',' : ''}${maxRepetitions ?? ''}}';
    } else {
      return pattern;
    }
  }

  /// Applies prefix and suffix to the pattern.
  String _applyPrefixSuffix(String pattern) {
    if (prefix != null) pattern = RegExp.escape(prefix!) + pattern;
    if (suffix != null) pattern = pattern + RegExp.escape(suffix!);
    return pattern;
  }

  /// Applies lookaround assertions to the pattern.
  String _applyLookarounds(String pattern) {
    String lookaheads = '';

    if (mustContain.isNotEmpty) {
      for (final contain in mustContain) {
        lookaheads += '(?=.*${RegExp.escape(contain)})';
      }
    }

    if (mustNotContain.isNotEmpty) {
      for (final notContain in mustNotContain) {
        lookaheads += '(?!.*${RegExp.escape(notContain)})';
      }
    }

    return lookaheads + (pattern.isNotEmpty ? pattern : '.*');
  }

  /// Applies word constraints to the pattern.
  String _applyWordConstraints(String pattern) {
    if (allowedWords.isNotEmpty) {
      final allowedPattern = allowedWords.map(RegExp.escape).join('|');
      pattern = '(?:$allowedPattern)';
    }
    if (disallowedWords.isNotEmpty) {
      pattern =
          '(?!.*(?:${disallowedWords.map(RegExp.escape).join('|')})).*$pattern';
    }
    return pattern;
  }

  /// Applies a custom pattern if provided.
  String _applyCustomPattern(String pattern) {
    return customPattern.isNotEmpty ? customPattern : pattern;
  }

  /// Generates a RegExp for email validation.
  RegExp _emailRegExp() {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for URL validation.
  RegExp _urlRegExp() {
    return RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for phone number validation.
  RegExp _phoneRegExp() {
    return RegExp(
      r'^\+?[1-9]\d{1,14}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for IPv4 address validation.
  RegExp _ipv4RegExp() {
    return RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for IPv6 address validation.

  /// Generates a RegExp for IPv6 address validation.
  ///
  /// This pattern covers most common IPv6 formats, including compressed notations.
  RegExp _ipv6RegExp() {
    return RegExp(
      r'^(?:(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,7}:|'
      r'(?:[0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,5}(?::[0-9a-fA-F]{1,4}){1,2}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,4}(?::[0-9a-fA-F]{1,4}){1,3}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,3}(?::[0-9a-fA-F]{1,4}){1,4}|'
      r'(?:[0-9a-fA-F]{1,4}:){1,2}(?::[0-9a-fA-F]{1,4}){1,5}|'
      r'[0-9a-fA-F]{1,4}:(?:(?::[0-9a-fA-F]{1,4}){1,6})|'
      r':(?:(?::[0-9a-fA-F]{1,4}){1,7}|:)|'
      r'fe80:(?::[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|'
      r'::(?:ffff(?::0{1,4}){0,1}:){0,1}(?:(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])|'
      r'(?:[0-9a-fA-F]{1,4}:){1,4}:(?:(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for hexadecimal color code validation.
  ///
  /// Matches 3 or 6 digit hexadecimal color codes prefixed with '#'.
  RegExp _hexColorRegExp() {
    return RegExp(
      r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for date validation.
  ///
  /// If a dateFormat is provided, it uses that format.
  /// Otherwise, it defaults to the format 'YYYY-MM-DD'.
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

  /// Generates a RegExp for time validation.
  ///
  /// If a timeFormat is provided, it uses that format.
  /// Otherwise, it defaults to the format 'HH:mm:ss'.
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

  /// Generates a RegExp for latitude validation.
  ///
  /// Matches latitude values between -90 and 90 degrees.
  RegExp _latitudeRegExp() {
    return RegExp(
      r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for longitude validation.
  ///
  /// Matches longitude values between -180 and 180 degrees.
  RegExp _longitudeRegExp() {
    return RegExp(
      r'^[-+]?((1[0-7]\d|[1-9]\d?)\.\d+|180(\.0+)?)$',
      caseSensitive: !caseInsensitive,
      multiLine: multiLine,
      dotAll: dotAll,
      unicode: true,
    );
  }

  /// Generates a RegExp for credit card number validation.
  ///
  /// If supportedCreditCards is empty, it matches all supported card types.
  /// Otherwise, it only matches the specified card types.
  RegExp _creditCardRegExp() {
    if (supportedCreditCards.isNotEmpty) {
      return RegExp(supportedCreditCards
          .map((card) => _getCreditCardPattern(card))
          .join('|'));
    }
    return RegExp(r'^\d{13,19}$');
  }

  /// Returns the RegExp pattern for a specific credit card type.
  ///
  /// [cardType] The type of credit card (e.g., 'visa', 'mastercard').
  /// Returns a default pattern for unrecognized card types.
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

  /// Converts a time format string to a regular expression pattern.
  ///
  /// [format] The time format string (e.g., "HH:mm:ss").
  /// Returns a string representing the regular expression pattern for the given time format.
  String _convertTimeFormatToRegex(String format) {
    return format
        .replaceAll('HH', r'(?:[01]\d|2[0-3])') // Hours in 24-hour format
        .replaceAll('mm', r'[0-5]\d') // Minutes
        .replaceAll('ss', r'[0-5]\d'); // Seconds
  }

  /// Converts a date format string to a regular expression pattern.
  ///
  /// [format] The date format string (e.g., "YYYY-MM-DD").
  /// Returns a string representing the regular expression pattern for the given date format.
  String _convertDateFormatToRegex(String format) {
    return format
        .replaceAll('YYYY', r'\d{4}') // Year
        .replaceAll('MM', r'(?:0[1-9]|1[0-2])') // Month
        .replaceAll('DD', r'(?:0[1-9]|[12]\d|3[01])'); // Day
  }
}
