library graph;

import 'dart:collection';
import 'package:uuid/uuid.dart';

part 'node.dart';
part 'utils.dart';
part 'edge.dart';
part 'graphs/items.dart';
part 'graphs/directed.dart';
part 'graphs/undirected.dart';
part 'graphs/get.dart';
part 'graphs/full.dart';


abstract class Graph implements UndirectedGraph, DirectedGraph, GraphGet {
  factory Graph() = FullGraph;
}

