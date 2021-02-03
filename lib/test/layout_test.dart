import 'package:flutter_test/flutter_test.dart';
import 'package:graph/graph.dart';

void main() {
  test('Connected Graph layout', () {
    final g = Graph();

    g.link(1, 2);
    g.link(1, 3);
    g.link(3, 4);
    g.link(2, 4);

    final layout = g.layout();
    for (final element in layout.keys) {
      print('$element: ${layout[element]}');
    }
  });
}
