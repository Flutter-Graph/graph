import 'package:graph/src/ui/graph_renderer.dart';

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
  
}
