class Environment {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'OpenFoodFacts testing App',
  );
}
