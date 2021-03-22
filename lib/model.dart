
import 'dart:ui';

class Luck{
  final String image;
  final Color color;
  final int value;

  Luck(this.image, this.color, this.value);


  String get asset =>  "asset/image/$image.png";
}