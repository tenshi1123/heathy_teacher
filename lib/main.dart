import 'package:flutter/material.dart';
import 'package:heathy_teacher/app.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //   initializeDateFormatting().then((_) => runApp(const App()));
  // });
  initializeDateFormatting().then((_) => runApp(const App()));
}
