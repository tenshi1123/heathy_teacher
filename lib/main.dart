import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heathy_teacher/app.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:intl/date_symbol_data_local.dart';

List<CourseModel> cartItems = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    initializeDateFormatting().then((_) => runApp(const App()));
  });
}
