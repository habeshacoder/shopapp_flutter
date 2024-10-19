import 'package:hive/hive.dart';

class MoodBox {
  static Future<Box<T>> open<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    } else {
      return await Hive.openBox(name);
    }
  }
}
