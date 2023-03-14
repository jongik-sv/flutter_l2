import '../const/data.dart';

class DataUtils {
  static String pathToUrl(String url) {
    return 'http://${ip}${url}';
  }

  static List<String> listPathsToUrl(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
