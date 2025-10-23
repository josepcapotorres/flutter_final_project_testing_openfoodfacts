class Environment {
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'prod',
  );
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.com',
  );
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'OpenFoodFacts testing App',
  );

  static bool get isTesters => flavor == 'testers';
  static bool get isProd => flavor == 'prod';
}
