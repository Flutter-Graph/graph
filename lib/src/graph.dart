import 'package:flutter/rendering.dart';
import 'package:graph/src/ui/graph_renderer.dart';
import 'package:graph/src/ui/paint_delegate.dart';

import 'list_graph.dart';
import 'ui/graph_listener.dart';
import 'vertex.dart';
import 'edge.dart';

class Graph extends ListGraph<Vertex, Edge> {
  GraphRenderer renderer;
  Graph([bool isDirected = false]) : super(directed: isDirected);

  GraphListener graphListener;

  addGraphListener(GraphListener graphListener) {
    this.graphListener = graphListener;
    graphListener.repaintGraph();
  }

  void registerPaintCallback(Function(PaintDelegate delegate) r) =>
      renderer.rebuild = r;

  void sizeChanged(Size s) => renderer.size = s;
}
