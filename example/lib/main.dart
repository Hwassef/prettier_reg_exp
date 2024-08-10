import 'package:flutter/material.dart';
import 'package:prettier_reg_exp/prettier_reg_exp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrettierRegExp Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PrettierRegExp Examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _exampleOutput = '';

  void _generateExamples() {
    setState(() {
      try {
        // Example 1: Email Validation
        final emailPattern = PrettierRegExp(isEmail: true).generate();
        final emailMatch = emailPattern.hasMatch('example@example.com');
        _exampleOutput += 'Email pattern: ${emailPattern.pattern}\n';
        _exampleOutput += 'Email match: $emailMatch\n';

        // Example 2: URL Validation
        final urlPattern = PrettierRegExp(isUrl: true).generate();
        final urlMatch = urlPattern.hasMatch('https://example.com');
        _exampleOutput += 'URL pattern: ${urlPattern.pattern}\n';
        _exampleOutput += 'URL match: $urlMatch\n';

        // Example 3: Phone Number Validation
        final phonePattern = PrettierRegExp(isPhoneNumber: true).generate();
        final phoneMatch = phonePattern.hasMatch('+1234567890');
        _exampleOutput += 'Phone number pattern: ${phonePattern.pattern}\n';
        _exampleOutput += 'Phone number match: $phoneMatch\n';

        // Example 4: Custom Pattern with Length Constraints
        final customPattern = PrettierRegExp(
          supportLetters: true,
          minLength: 5,
          maxLength: 10,
          prefix: 'user_',
          suffix: '_dev',
        ).generate();
        final customMatch = customPattern.hasMatch('user_example_dev');
        _exampleOutput += 'Custom pattern: ${customPattern.pattern}\n';
        _exampleOutput += 'Custom match: $customMatch\n';

        // Example 5: Credit Card Validation
        final creditCardPattern = PrettierRegExp(
          isCreditCard: true,
          supportedCreditCards: ['visa', 'mastercard'],
        ).generate();
        final creditCardMatch = creditCardPattern.hasMatch('4111111111111111');
        _exampleOutput += 'Credit card pattern: ${creditCardPattern.pattern}\n';
        _exampleOutput += 'Credit card match: $creditCardMatch\n';
      } catch (e) {
        _exampleOutput = 'Error generating patterns: $e';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _generateExamples,
              child: const Text('Generate Regex Examples'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _exampleOutput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
