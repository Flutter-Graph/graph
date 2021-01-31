import '../../graph.dart';

class PaintDelegate {
 
  final List<Vertex> vertex;
  final List<Vertex> oldVertex;
  final List<Vertex> changed;

  PaintDelegate(this.vertex,this.oldVertex, this.changed);

}
