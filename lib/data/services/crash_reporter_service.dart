import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashReporterService {
  final FirebaseCrashlytics _crashlytics;

  CrashReporterService(this._crashlytics);

  Future<void> recordError(dynamic exception, StackTrace? stack) =>
      _crashlytics.recordError(exception, stack);

  Future<void> log(String message) => _crashlytics.log(message);
}
