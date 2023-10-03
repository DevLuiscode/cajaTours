import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiurl = dotenv.env['API_URL'] ?? 'No esta configurado la Api';
}
