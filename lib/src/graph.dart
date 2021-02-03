library graph;

import 'package:flutter/rendering.dart';
import 'package:graph/graph.dart';
import 'package:some/index.dart';
import 'dart:collection';
import 'dart:math' as math;

part 'node.dart';
part 'utils.dart';
part './graphs/items.dart';
part './graphs/directed.dart';
part './graphs/directed.value.dart';
part './graphs/undirected.dart';
part './graphs/undirected.value.dart';
part './graphs/get.dart';
part './graphs/full.dart';
part './layout/graph_layout.dart';

/// Contains [DirectedGraph] and [UndirectedGraph], And can't set the value of the edge
abstract class LinkGraph implements UndirectedGraph, DirectedGraph,GraphLayout {
  factory LinkGraph() = FullGraph;
}

/// Contains all types of Graph, The difference with [LinkGraph] is that you can set the value of the edge.
abstract class Graph extends LinkGraph
    implements UndirectedValueGraph, DirectedValueGraph,GraphLayout {
  factory Graph() = FullGraph;
}
