import 'base_edge_properties.dart';
import 'base_vertex.dart';

class BaseEdge<VertexType extends BaseVertex>
    implements Comparable<BaseEdge<VertexType>> {
  BaseEdgeProperties prop;

  final VertexType source;
  final VertexType target;

  int edgeIterationIndex = 0;

  BaseEdge(this.source, this.target, this.prop);

  BaseEdge getCopy(VertexType v1, VertexType v2) {
    return BaseEdge(v1, v2,  prop);
  }

  int get color => prop.color;

  set color(newColor) => prop.color = newColor;

  int get weight => prop.weight;

  set weight(newWeight) => prop.weight = newWeight;

  bool get isMarked => prop.mark;

  set mark(newMark) => prop.mark = newMark;

  @override
  String toString() {
    return "Edge: $source -> $target";
  }

  compareTo(BaseEdge<VertexType> o) {
    return prop.weight.compareTo(o.prop.weight);
  }
}
