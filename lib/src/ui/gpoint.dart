import 'dart:math';

class GPoint {
  double x;
  double y;

  GPoint._(this.x, this.y);

  factory GPoint.zero() {
    return GPoint._(0, 0);
  }

  factory GPoint(double x, double y) {
    return GPoint(x, y);
  }

  double get length => sqrt(pow(x, 2) + pow(y, 2));

  GPoint normalise() {
    return this / this.length;
  }

  String toString() {
    return "$x,$y";
  }

  double distance(GPoint pt) {
    double px = pt.x - x;
    double py = pt.y - y;
    return sqrt(px * px + py * px);
  }

  GPoint operator -(GPoint other) {
    return GPoint(x - other.x, y -other.y);
  }

  GPoint operator +(GPoint other) {
    return GPoint(x+ other.x, y + other.y);
  }

  GPoint operator *(double scalar) {
    return GPoint(x*scalar, y*scalar);
  }

  GPoint operator /(double scalar) {
    return GPoint(x/scalar, y/scalar);
  }
}
