import 'dart:math';

class RandomString {
  static final random = Random();
  static final chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String generate(int length) {
    return List.generate(length, (index) {
      return chars[random.nextInt(chars.length)];
    }).join();
  }
}
