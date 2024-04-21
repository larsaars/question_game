import 'dart:math';
import 'dart:ui';

Color createRandomPastelBackgroundColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(0.2);
}
