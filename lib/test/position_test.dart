import 'package:flutter_test/flutter_test.dart';

import 'package:graph/graph.dart';

void main() {
  test('[position] set and change', () {
    final g = Graph();
    g.add(1);

    expect(g.getPos(1).has, isTrue);
    expect(g.getPos(1).val == VectorPosition.zero, isTrue);

    final position = VectorPosition(1, 10);
    expect(g.setPos(1, position), isTrue);
    expect(g.getPos(1).val == position, isTrue);
  });

  test('Conneced graph check', () {
    final g = Graph();

    g.add(1);
    expect(g.isConnected, isTrue);

    g.add(2);
    expect(g.isConnected, isFalse);

    g.linkTo(1, 2);
    expect(g.isConnected, isTrue);

    g.unLinkTo(1, 2);
    g.link(1, 2);
    expect(g.isConnected, isTrue);

    g.add(3);
    expect(g.isConnected, isFalse);
  });
}
