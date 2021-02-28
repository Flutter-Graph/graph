import 'package:test/test.dart';

import 'package:graph/graph.dart';

void main() {
  test('create', () {
    Graph();
  });

  test('[base] add, has', () {
    final g = Graph();

    final n1 = Node.fromVal('val');

    final n1Id = g.add(n1);
    expect(n1Id == n1.id, isTrue);
    expect(g.has(n1), isTrue);
    expect(g.has(n1.id), isTrue);
    expect(g.has('sadg'), isFalse);
    expect(g.length, 1);

    final n2Id = g.add('tada');
    expect(g.length, 2);
    expect(g.has(n2Id), isTrue);
    expect(g.has(n1Id), isTrue);
  });

  test('[base] add, has, remove', () {
    final g = Graph();
    final n1 = g.add(Node.fromVal(1));
    final n2 = g.add(Node.fromVal(1));

    expect(g, hasLength(2));
    expect(g.has(n1), isTrue);
    expect(g.has(n2), isTrue);

    expect(g.remove(n1), isTrue);
    expect(g.remove(n1), isFalse);
    expect(g, hasLength(1));
    expect(g.has(n1), isFalse);
    expect(g.has(n2), isTrue);
  });

  test('[link] add has remove', () {
    final g = Graph();

    final n1 = Node.fromVal(1);
    final n2 = Node.fromVal(1);
    g.link(n1, n2);

    expect(g, hasLength(2));
    expect(g.has(n1), isTrue);
    expect(g.has(n2), isTrue);

    expect(g.hasLink(n1, n2), isTrue);
    expect(g.hasLink(n2, n1), isTrue);

    expect(g.neighbours(n1), contains(n2));
    expect(g.neighbours(n2),contains(n1));

    expect(g.neighbours(n1), hasLength(1));
    expect(g.neighbours(n2), hasLength(1));

    expect(g.unLink(n1, n2), isTrue);
    expect(g.unLink(n1, n2), isFalse);

    expect(g, hasLength(2));
    expect(g.has(n1), isTrue);
    expect(g.has(n1), isTrue);
  });

  test('[link to] add has remove', () {
    final g = Graph();

    final n1 = Node.fromVal(1);
    final n2 = Node.fromVal(1);
    g.linkTo(n1, n2);

    expect(g, hasLength(2));
    expect(g.has(n1), isTrue);
    expect(g.has(n2), isTrue);

    expect(g.hasLinkTo(n1, n2), isTrue);
    expect(g.hasLinkTo(n2, n1), isFalse);

    expect(g.hasLink(n1, n2), isTrue);
    expect(g.hasLink(n2, n1), isTrue);
    expect(g.hasLink(n2, n1, edgeType: EdgeType.undirected), isFalse);
    expect(g.hasLink(n2, n1, edgeType: EdgeType.undirected), isFalse);
    expect(g.hasLink(n1, n2, edgeType: EdgeType.directed), isTrue);
    expect(g.hasLink(n2, n1, edgeType: EdgeType.directed), isTrue);

    expect(g.neighbours(n1), contains(n2));

    expect(g.neighbours(n1), hasLength(1));
    expect(g.neighbours(n2), hasLength(0));

    expect(g.linksTo(n1).first.target, n2);
    expect(g.linksTo(n1), hasLength(1));
    expect(g.linksTo(n2), hasLength(0));

    expect(g.linksFrom(n2).first.source, n1);
    expect(g.linksFrom(n2), hasLength(1));
    expect(g.linksFrom(n1), hasLength(0));

    expect(g.unLinkTo(n1, n2), isTrue);
    expect(g.unLinkTo(n1, n2), isFalse);

    expect(g, hasLength(2));
    expect(g.has(n1), isTrue);
    expect(g.has(n2), isTrue);
  });

  test('types', () {
    dynamic g = Graph();
    UndirectedGraph ug = g;
    DirectedGraph dg = g;
    GraphGet ge = g;
    ug;
    dg;
    ge;
  });

  test('loop', () {
    final g = Graph();

    final edge1 = g.link(1, 2, value: 'n1 to n2: undirected');
    final n1 = edge1.source;
    final n2 = edge1.target;
    final edge2 = g.link(n1, 3, value: 'n1 to n3: undirected');
    final n3 = edge2.target;
    final n4 = Node.fromVal(1);
    g.linkTo(n3, n4, value: 'n3 to n4: directed');
    g.linkTo(n4, n2, value: 'n4 to n2: directed');

    expect(g, hasLength(4));
    expect(g.items, containsAll([n1, n2, n3, n4]));
    expect(g.has(n1), isTrue);
    expect(g.has(n2), isTrue);
    expect(g.has(n3), isTrue);
    expect(g.has(n4), isTrue);

    expect(g.links(), hasLength(6));

    // check connection n1 <-> n2
    expect(g.hasLink(n1, n2), isTrue);
    expect(g.hasLink(n2, n1), isTrue);
    expect(g.hasLinkTo(n2, n1), isTrue);
    expect(g.hasLinkTo(n1, n2), isTrue);
    expect(g.hasLinkTo(n2, n1, edgeType: EdgeType.undirected), isTrue);
    expect(g.hasLinkTo(n1, n2, edgeType: EdgeType.undirected), isTrue);
    expect(g.hasLinkTo(n2, n1, edgeType: EdgeType.directed), false);
    expect(g.hasLinkTo(n1, n2, edgeType: EdgeType.directed), false);

    expect(g.neighbours(n2), contains(n1));
    expect(g.neighbours(n1), contains(n2));

    // check connection n1 <-> n3
    expect(g.hasLink(n1, n3), isTrue);
    expect(g.hasLink(n3, n1), isTrue);
    expect(g.hasLinkTo(n3, n1), isTrue);
    expect(g.hasLinkTo(n1, n3), isTrue);
    expect(g.hasLinkTo(n3, n1, edgeType: EdgeType.undirected), isTrue);
    expect(g.hasLinkTo(n1, n3, edgeType: EdgeType.undirected), isTrue);
    expect(g.hasLinkTo(n3, n1, edgeType: EdgeType.directed), isFalse);
    expect(g.hasLinkTo(n1, n3, edgeType: EdgeType.directed), isFalse);

    expect(g.neighbours(n3), contains(n1));
    expect(g.neighbours(n1), contains(n3));

    // check connection n3 -> n4
    expect(g.hasLink(n3, n4), isTrue);
    expect(g.hasLink(n4, n3), isTrue);
    expect(g.hasLink(n3, n4, edgeType: EdgeType.directed), isTrue);
    expect(g.hasLink(n4, n3, edgeType: EdgeType.directed), isTrue);
    expect(g.hasLink(n3, n4, edgeType: EdgeType.undirected), isFalse);
    expect(g.hasLink(n4, n3, edgeType: EdgeType.undirected), isFalse);

    expect(g.hasLinkTo(n3, n4), isTrue);
    expect(g.hasLinkTo(n4, n3), isFalse);
    expect(g.hasLinkTo(n3, n4, edgeType: EdgeType.directed), true);
    expect(g.hasLinkTo(n3, n4, edgeType: EdgeType.undirected), isFalse);

    expect(g.neighbours(n3), contains(n4));
    expect(g.neighbours(n4).contains(n3), isFalse);

    // check connection n4 -> n2
    expect(g.hasLink(n2, n4), isTrue);
    expect(g.hasLink(n4, n2), isTrue);
    expect(g.hasLink(n2, n4, edgeType: EdgeType.directed), isTrue);
    expect(g.hasLink(n4, n2, edgeType: EdgeType.directed), isTrue);
    expect(g.hasLink(n2, n4, edgeType: EdgeType.undirected), isFalse);
    expect(g.hasLink(n4, n2, edgeType: EdgeType.undirected), isFalse);

    expect(g.hasLinkTo(n4, n2), isTrue);
    expect(g.hasLinkTo(n2, n4), isFalse);
    expect(g.hasLinkTo(n4, n2, edgeType: EdgeType.directed), true);
    expect(g.hasLinkTo(n4, n2, edgeType: EdgeType.undirected), isFalse);

    expect(g.neighbours(n4), contains(n2));
    expect(g.neighbours(n2).contains(n4), isFalse);
  });
}
