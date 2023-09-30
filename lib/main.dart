import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/person_model.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentsDiretory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDiretory.path);
  Hive.registerAdapter(PersonModelAdapter());
  runApp(const MyApp());
}
