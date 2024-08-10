## PrettierRegExp

<a href="https://www.buymeacoffee.com/Hwassef" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

**Introduction**

PrettierRegExp is a powerful Dart package that streamlines regular expression creation and management. It empowers you to effortlessly validate and parse input data using customizable patterns and constraints, ensuring data integrity and accuracy in your applications.

**Key Features**

| Feature | Description |
|---|---|
| Concise Pattern Creation | Define intricate regex patterns with a wide array of character types, simplifying the process. |
| Predefined Patterns | Generate common regexes for email addresses, URLs, phone numbers, and more, saving you time and effort. |
| Lookaheads & Lookbehinds | Leverage these advanced techniques to match or exclude specific patterns based on their presence or absence. |
| Precise Length Constraints | Define minimum and maximum length requirements for your patterns, ensuring data adherence to desired formats. |
| Flexible Repetition Constraints | Specify exact or range-based repetitions of patterns, catering to diverse input structures. |
| Effortless Prefixes & Suffixes | Add prefixes or suffixes to your patterns with ease, enhancing their flexibility. |
| Granular Word Constraints | Include or exclude specific words within your patterns, enabling targeted validation. |

**Getting Started**

**1. Dependency Addition:**

In your `pubspec.yaml` file, incorporate the following line:

yaml
```
dependencies:
  prettier_reg_exp: ^1.0.0
 ```

2. Package Installation:

Run the following command in your terminal to install the package:

flutter pub get

Usage Examples

Basic Length Constraints

Enforce minimum and maximum length requirements for patterns:

Dart
```

import 'package:prettier_reg_exp/prettier_reg_exp.dart';

void main() {
  final regex = PrettierRegExp(minLength: 3, maxLength: 5).generate();
  print(regex.hasMatch('abc'));  // true (matches 3 characters)
  print(regex.hasMatch('abcdef')); // false (exceeds 5 characters)
}
```

Email Validation

Generate a regex specifically for validating email addresses:

Dart
```
import 'package:prettier_reg_exp/prettier_reg_exp.dart';

void main() {
  final regex = PrettierRegExp(isEmail: true).generate();
  print(regex.hasMatch('example@example.com')); // true (valid email format)
  print(regex.hasMatch('invalid-email'));        // false (invalid format)
}
```

Custom Patterns with Constraints

Define a regex with tailored constraints:

Dart
```
import 'package:prettier_reg_exp/prettier_reg_exp.dart';

void main() {
  final regex = PrettierRegExp(
    customPattern: r'^[a-zA-Z0-9]{8,12}$', // 8-12 alphanumeric characters
    mustContain: ['abc'],             // Must include "abc"
    mustNotContain: ['xyz'],           // Must not include "xyz"
  ).generate();

  print(regex.hasMatch('abcdefgh')); // true (matches constraints)
  print(regex.hasMatch('abcdxyz'));  // false (violates "mustNotContain")
}
```

Additional Resources

Contributing: Enhance the package further! Please refer to the contributing guidelines (link to be provided) for guidance on how to contribute your valuable code.

Issues: Encountered a bug or have a feature request? Open an issue on GitHub (link to be provided) to report it.

Happy Regex Crafting!

