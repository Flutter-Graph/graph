import 'base_edge.dart';
import 'base_edge_properties.dart';
import 'ui/edge_listener.dart';
import 'vertex.dart';

class Edge extends BaseEdge<Vertex> {
  Edge(Vertex source, Vertex target, BaseEdgeProperties prop)
      : super(source, target, prop);

  EdgeListener view;
  bool changed;

  void setEdgeListener(EdgeListener listener) {
    this.view = listener;
  }
}
