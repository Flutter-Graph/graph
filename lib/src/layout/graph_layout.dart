part of graph;

abstract class GraphLayout {

  ///return the layout of each node + edges
  Map<dynamic, VectorPosition> layout() {
    if (_isConnectedGraph()) {
      return _connectedGraphLayout();
    } else {
      return _unconnectedGraphLayout();
    }
  }

  Map<dynamic, VectorPosition> _connectedGraphLayout();

  Map<dynamic, VectorPosition> _unconnectedGraphLayout();

  bool _isConnectedGraph();
}

mixin GraphLayoutMixin on GraphItemsMixin implements GraphLayout{

}
