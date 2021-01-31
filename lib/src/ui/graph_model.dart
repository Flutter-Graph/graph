import '../../graph.dart';

class GraphModel {
  final List<Vertex> vertecies;
  final List<Edge> edges;
  bool allChanged;

  GraphModel(this.vertecies, this.edges) : allChanged = true;

  void markVertexRepaint(Vertex vertex) {
    vertecies.singleWhere((e) => e.id == vertex.id).changed = true;
    edges
        .where((e) => e.source == vertex || e.target == vertex)
        .forEach((edge) => edge.changed = true);
  }

  void markEdgeRepaint(Edge edge) {
    edges
        .singleWhere((e) => e.source == edge.source && e.target == edge.target)
        .changed = true;
  }

  void markAllRepaint() => allChanged = true;
}
