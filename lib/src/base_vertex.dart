import 'package:graph/src/base_vertex_properties.dart';

class BaseVertex {
  BaseVertexProperties prop;
  List<int> subgraphIds;
  int id;

  BaseVertex(this.prop);

  @override
  String toString() {
    return "v$id";
  }

  BaseVertex getCopy() {
    return BaseVertex(this.prop);
  }

  get color => prop.color;

  set color(newColor) => prop.color = newColor;

  get isMarked => prop.mark;

  set mark(newMark) => prop.mark = newMark;

  int getSubgraphId(int index) => subgraphIds[index - 1];

  void informNewSubgraph() {
    if (subgraphIds == null) {
      subgraphIds = [];
    }
    subgraphIds.add(0);
  }

  int setSubgraphId(int index, int id) {
    return subgraphIds[index] = id;
  }
}
