part of graph;

class Edge {
  final bool directed;
  final String? sharedId;
  final Node source;
  final Node target;
  EdgeData value;
  final Set<dynamic> tags = {};

  Edge(this.source, this.target,
      {this.directed = true, this.sharedId, EdgeData? value})
      : value = value ?? DefaultEdgeData(1),
        assert(
            (directed && sharedId == null) || (!directed && sharedId != null),
            'If the edge is directed a sharedId must be provided otherwise sharedId must be null');

  bool isType(EdgeType edgeType) {
    switch (edgeType) {
      case EdgeType.all:
        return true;
      case EdgeType.directed:
        return directed;
      case EdgeType.undirected:
        return !directed;
    }
  }
}

enum EdgeType { all, directed, undirected }

abstract class EdgeData {
  double get weight;
}

class DefaultEdgeData extends EdgeData {
  @override
  double weight;

  DefaultEdgeData(this.weight);
}
