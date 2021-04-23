import 'dart:io';

import 'package:very_good_notes/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('images assets test', () {
    expect(true, File(Images.googleLoginButton).existsSync());
  });
}
