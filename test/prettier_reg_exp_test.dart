import 'package:flutter_test/flutter_test.dart';
import 'package:prettier_reg_exp/prettier_reg_exp.dart';

void main() {
  test('applies mustContain and mustNotContain correctly', () {
    final regex = PrettierRegExp(mustContain: ['abc'], mustNotContain: ['xyz'])
        .generate();

    expect(regex.hasMatch('abcdef'),
        isTrue); // Contains 'abc' and does not contain 'xyz'
    expect(regex.hasMatch('abxyz'), isFalse); // Contains 'xyz'
    expect(regex.hasMatch('abcxyz'), isFalse); // Contains 'xyz'
    expect(regex.hasMatch('xyzabc'), isFalse); // Contains 'xyz'
  });

  test('enforces length constraints', () {
    final regex = PrettierRegExp(minLength: 3, maxLength: 5).generate();
    expect(regex.hasMatch('ab'), isFalse); // Less than minLength
    expect(regex.hasMatch('abc'), isTrue); // Within range
    expect(regex.hasMatch('abcd'), isTrue); // Within range
    expect(regex.hasMatch('abcdef'), isFalse); // Exceeds maxLength
  });

  test('handles custom patterns', () {
    final regex = PrettierRegExp(customPattern: r'^foo.*bar$').generate();
    expect(regex.hasMatch('foo123bar'), isTrue);
    expect(regex.hasMatch('foobar'), isTrue);
    expect(regex.hasMatch('foobarbaz'), isFalse);
  });

  test('matches email addresses correctly', () {
    final regex = PrettierRegExp(isEmail: true).generate();
    expect(regex.hasMatch('test@example.com'), isTrue);
    expect(regex.hasMatch('invalid-email'), isFalse);
  });

  test('matches URLs correctly', () {
    final regex = PrettierRegExp(isUrl: true).generate();
    expect(regex.hasMatch('https://www.example.com'), isTrue);
    expect(regex.hasMatch('ftp://example.com'), isTrue);
    expect(regex.hasMatch('invalid-url'), isFalse);
  });

  test('matches phone numbers correctly', () {
    final regex = PrettierRegExp(isPhoneNumber: true).generate();
    expect(regex.hasMatch('+1234567890'), isTrue);
    expect(regex.hasMatch('1234567890'), isTrue);
    expect(regex.hasMatch('invalid-phone'), isFalse);
  });

  test('matches hex color codes correctly', () {
    final regex = PrettierRegExp(isHexColor: true).generate();
    expect(regex.hasMatch('#aabbcc'), isTrue);
    expect(regex.hasMatch('#abc'), isTrue);
    expect(regex.hasMatch('123456'), isFalse);
  });

  test('matches date format correctly', () {
    final regex =
        PrettierRegExp(isDate: true, dateFormat: 'YYYY-MM-DD').generate();
    expect(regex.hasMatch('2024-08-10'), isTrue);
    expect(regex.hasMatch('10-08-2024'), isFalse);
  });

  test('matches time format correctly', () {
    final regex =
        PrettierRegExp(isTime: true, timeFormat: 'HH:mm:ss').generate();
    expect(regex.hasMatch('14:30:00'), isTrue);
    expect(regex.hasMatch('2:30 PM'), isFalse);
  });

  test('matches latitude correctly', () {
    final regex = PrettierRegExp(isLatitude: true).generate();
    expect(regex.hasMatch('37.7749'), isTrue);
    expect(regex.hasMatch('90.0000'), isTrue);
    expect(regex.hasMatch('100.0000'), isFalse);
  });

  test('matches longitude correctly', () {
    final regex = PrettierRegExp(isLongitude: true).generate();
    expect(regex.hasMatch('-122.4194'), isTrue);
    expect(regex.hasMatch('180.0000'), isTrue);
    expect(regex.hasMatch('190.0000'), isFalse);
  });

  test('matches credit card numbers correctly', () {
    final regex = PrettierRegExp(
        isCreditCard: true,
        supportedCreditCards: ['visa', 'mastercard']).generate();
    expect(regex.hasMatch('4111111111111111'), isTrue); // Visa
    expect(regex.hasMatch('5500000000000004'), isTrue); // MasterCard
    expect(regex.hasMatch('340000000000009'), isFalse); // Amex (not included)
  });
}
