import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:altcha_widget/models/server_verification.dart';
import 'package:flutter/material.dart';
import 'package:altcha_widget/localizations.dart';
import 'package:altcha_widget/widget.dart';

void main() {
  runApp(const PreviewApp());
}

class PreviewApp extends StatefulWidget {
  const PreviewApp({super.key});

  @override
  State<PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<PreviewApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('en');

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
        Locale('pt'),
      ],
      locale: _locale,
      localizationsDelegates: [
        AltchaLocalizationsDelegate(
          customTranslations: {
            'en': {
              // Define translations keys here
            },
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'AltchaWidget Preview',
      home: AltchaDemoPage(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
        locale: _locale,
        onLocaleChanged: _setLocale,
      ),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
    );
  }
}

class AltchaDemoPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  const AltchaDemoPage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.locale,
    required this.onLocaleChanged,
  });

  @override
  State<AltchaDemoPage> createState() => _AltchaDemoPageState();
}

class _AltchaDemoPageState extends State<AltchaDemoPage> {
  final GlobalKey<AltchaWidgetState> _altchaKey = GlobalKey();

  final TextEditingController _challengeUrlController = TextEditingController(
    text: 'http://cp.local:8081/v1/challenge?apiKey=key_1jfi4j2ro00a0nsr8fr',
  );
  final TextEditingController _delayController = TextEditingController(
    text: '1000',
  );

  String _challengeUrl =
      'http://cp.local:8081/v1/challenge?apiKey=key_1jfi4j2ro00a0nsr8fr';
  int _delay = 1000;

  String? _verifiedValue;
  AltchaServerVerification? _serverVerification;

  // List of locales for dropdown
  final List<Locale> _locales = const [
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  @override
  void dispose() {
    _challengeUrlController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  void _updateParams() {
    setState(() {
      _challengeUrl = _challengeUrlController.text;
      _delay = int.tryParse(_delayController.text) ?? 1000;
      _verifiedValue = null;
      _serverVerification = null;
    });
    _altchaKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('AltchaWidget Preview')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _challengeUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Challenge URL',
                      ),
                      onSubmitted: (_) => _updateParams(),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _delayController,
                      decoration: const InputDecoration(
                        labelText: 'Delay (ms)',
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _updateParams(),
                    ),
                    const SizedBox(height: 16),
                    AltchaWidget(
                      key: _altchaKey,
                      challengeUrl: _challengeUrl,
                      delay: _delay,
                      onFailed: (e) {
                        print('altcha failed: $e');
                      },
                      onServerVerification:
                          (AltchaServerVerification verification) {
                            setState(() {
                              _serverVerification = verification;
                            });
                            print('altcha server verification $verification');
                          },
                      onVerified: (String value) {
                        setState(() {
                          _verifiedValue = value;
                        });
                        print('altcha verified: $value');
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateParams,
                      child: const Text('Update & Reset'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onToggleTheme,
                      child: Text(
                        isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Locale selection dropdown below buttons
                    Row(
                      children: [
                        const Text('Locale: '),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButton<Locale>(
                            isExpanded: true,
                            value: widget.locale,
                            items: _locales.map((locale) {
                              return DropdownMenuItem<Locale>(
                                value: locale,
                                child: Text(locale.languageCode.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (Locale? newLocale) {
                              if (newLocale != null) {
                                widget.onLocaleChanged(newLocale);
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (_verifiedValue != null || _serverVerification != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payload:',
                            style: TextStyle(fontSize: 12),
                          ),
                          if (_verifiedValue != null)
                            Text(
                              '$_verifiedValue',
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (_serverVerification != null)
                            Text(
                              'onServerVerification:\n${const JsonEncoder.withIndent('  ').convert(_serverVerification)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
