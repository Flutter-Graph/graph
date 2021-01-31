import 'dart:core';

import 'package:graph/src/base_edge.dart';
import 'package:graph/src/base_graph.dart';
import 'package:graph/src/base_vertex.dart';
import 'failures/exceptions.dart';
import 'utils/matrix.dart';
import 'utils/pair.dart';

class ListGraph<VertexType extends BaseVertex,
        EdgeType extends BaseEdge<VertexType>>
    extends BaseGraph<VertexType, EdgeType> {
  ListGraph({this.directed})
      : list = [],
        inverseList = [],
        vertices = [],
        outDegree = [],
        inDegree = [];

  //specified whether the graph is directed
  bool directed;

  //Number of edges / Graph order
  int edgeCount = 0;

  int edgeIterationIndex = 0;
  //Specified whether the graph is changed since the last light iteration
  bool guard = false;

  //Number of edges their source is connected to the vertex
  List<int> inDegree;

  //The reversed adjacency list data structure
  List<List<Pair<EdgeType, VertexType>>> inverseList;

  //The adjacency list data structure
  List<List<Pair<EdgeType, VertexType>>> list;

  //Number of edges their target is connected to the vertex
  List<int> outDegree;

  //List of vertices
  List<VertexType> vertices;

  @override
  Iterator<VertexType> get iterator => vertices.iterator;

  VertexType operator [](int i) => vertices[i];

  Iterable<EdgeType> get edges => EdgeIterabel<VertexType, EdgeType>(this);

  @override
  void checkVertex(VertexType vertex) {
    if (vertexIdOutOfRange(getId(vertex))) {
      String message = "Out of Range";

      if (vertices.contains(vertex)) {
        message +=
            ":It seems that this vertex exists in two different graph objects. This is illegal.";
        throw new InvalidVertexException(message);
      }
    }

    if (vertex != vertices[getId(vertex)])
      throw new InvalidVertexException("Invalid");
  }

  @override
  void clear() {
    list = [];
    inverseList = [];
    vertices = [];
    outDegree = [];
    inDegree = [];
    edgeIterationIndex = 0;
    guard = false;
  }

  @override
  bool containsVertex(VertexType vertex) {
    return vertices.contains(vertex);
  }

  @override
  Iterator<EdgeType> edgeIterator({VertexType vertex, bool source}) {
    return EdgeIterator(this, vertex: vertex, source: source);
  }

  @override
  Matrix getAdjacencyMatrix() {
    Matrix matrix = Matrix(getVerticesCount(), getVerticesCount());

    Iterator<EdgeType> it = edgeIterator();
    int targetId;
    int sourceId;
    double newValue;

    while (it.moveNext()) {
      EdgeType edge = it.current;

      targetId = getId(edge.target);
      sourceId = getId(edge.source);
      newValue = matrix[sourceId][targetId] + 1;

      matrix[sourceId][targetId] = newValue;
      if (!directed) matrix[targetId][sourceId] = newValue;
    }

    return matrix;
  }

  @override
  List<List<int>> getEdgeList() {
    final array = [];
    for (final ll in list) {
      array.add(ll.map((e) => getId(e.second)).toList());
    }
    return array;
  }

  @override
  List<EdgeType> getEdges(VertexType source, VertexType target) {
    return list[source.id]
        .where((e) => e.first.target == target)
        .map((e) => e.first);
  }

  @override
  int getEdgesCount() {
    return edgeCount;
  }

  @override
  int getInDegree(VertexType vertex) {
    checkVertex(vertex);
    return inverseList[getId(vertex)].length;
  }

  @override
  int getOutDegree(VertexType vertex) {
    checkVertex(vertex);
    return list[getId(vertex)].length;
  }

  @override
  List<BaseVertex> getVertexList() {
    return this.toList();
  }

  @override
  int getVerticesCount() {
    return vertices.length;
  }

  @override
  Matrix getWeightedAdjacencyMatrix() {
    Matrix matrix = Matrix(getVerticesCount(), getVerticesCount());

    Iterator<EdgeType> it = edgeIterator();
    int targetId;
    int sourceId;
    double newValue;

    while (it.moveNext()) {
      EdgeType edge = it.current;

      targetId = getId(edge.target);
      sourceId = getId(edge.source);
      newValue = matrix[sourceId][targetId] + edge.weight;

      matrix[sourceId][targetId] = newValue;
      if (!directed) matrix[targetId][sourceId] = newValue;
    }

    return matrix;
  }

  @override
  void insertEdge(EdgeType newEdge) {
    int target = getId(newEdge.target);
    int source = getId(newEdge.source);

    checkVertex(newEdge.source);
    checkVertex(newEdge.target);

    guard = true;

    list[source].add(Pair<EdgeType, VertexType>(newEdge, newEdge.target));
    if (!directed)
      list[target].add(Pair<EdgeType, VertexType>(newEdge, newEdge.source));

    inverseList[target]
        .add(Pair<EdgeType, VertexType>(newEdge, newEdge.source));
    if (!directed)
      inverseList[source]
          .add(Pair<EdgeType, VertexType>(newEdge, newEdge.target));

    outDegree[source] = outDegree[source] + 1;
    inDegree[target] = inDegree[target] + 1;

    if (!directed) {
      inDegree[source] = inDegree[source] + 1;
      outDegree[target] = outDegree[target] + 1;
    }

    ++edgeCount;
  }

  @override
  void insertVertex(VertexType newVertex) {
    if (!vertices.contains(newVertex)) {
      guard = true;
      vertices.add(newVertex);
      list.add([]);
      inverseList.add([]);
      setId(newVertex, vertices.length - 1);
      inDegree.add(0);
      outDegree.add(0);
    } else {
      throw new IllegalArgumentException("Adding duplicate vertex.");
    }
  }

  @override
  bool isConnected(VertexType source, VertexType target) {
    final edges = getEdges(source, target);
    return edges != null && edges.isNotEmpty;
  }

  @override
  bool isDirected() {
    return directed;
  }

  @override
  void removeAllEdges(VertexType source, VertexType target) {
    final List<EdgeType> edges = inverseList[source.id]
        .where((element) => element.first.target == target)
        .map((e) => e.first);
    for (final edge in edges) {
      removeEdge(edge);
    }
  }

  @override
  void removeEdge(EdgeType edge) {
    checkVertex(edge.source);
    checkVertex(edge.target);

    VertexType source = edge.source;
    VertexType target = edge.target;

    guard = true;

    list = this.list;

    for (int i = 0; i < 2; i++) {
      if (i == 1) {
        list = this.inverseList;
        final temp = source;
        source = target;
        target = temp;
      }

      final List<Pair<EdgeType, VertexType>> edges =
          list[source.id].where((e) => e.second == target);
      for (final edge in edges) {
        list[source.id].remove(edge);
      }

      if (directed) {
        continue;
      }

      final List<Pair<EdgeType, VertexType>> inversedEdges =
          list[target.id].where((e) => e.second == target);
      for (final edge in inversedEdges) {
        list[target.id].remove(edge);
      }
    }

    edgeCount--;
  }

  @override
  void removeVertex(VertexType vertex) {
    guard = true;
    inverseList[vertex.id].forEach((edge) => removeEdge(edge.first));

    int vId = getId(vertex);
    list.remove(vId);
    inverseList.remove(vId);
    vertices.remove(vId);
    inDegree.remove(vId);
    outDegree.remove(vId);
    _updateVertexIds();
  }

  _updateVertexIds() {
    try {
      for (int i = 0; i < getVerticesCount(); i++) setId(getVertex(i), i);
    } catch (e) {
      print(e);
    }
  }

  //returns 0 if there is no edge between source and
  @override
  int weightOfEdge(VertexType source, VertexType target) {
    if (isConnected(source, target)) {
      return getEdges(source, target).map((e) => e.weight).first;
    }
    return 0;
  }

  void setId(VertexType vertex, int id) {
    if (subgraphIndex != 0) {
      vertex.setSubgraphId(subgraphIndex, id);
      return;
    }
    vertex.id = id;
  }

  bool vertexIdOutOfRange(int id) {
    return id < 0 || id >= vertices.length;
  }

  VertexType getVertex(int id) {
    if (vertexIdOutOfRange(id)) {
      throw InvalidVertexException("Id out of range");
    }

    return vertices[id];
  }
}

class EdgeIterator<VertexType extends BaseVertex,
    EdgeType extends BaseEdge<VertexType>> implements Iterator<EdgeType> {
  EdgeIterator(this.graph, {VertexType vertex, bool source}) {
    graph.edgeIterationIndex++;

    if (vertex != null) graph.checkVertex(vertex);

    List<EdgeType> edges = [];

    if (source == null) {
      for (final vertex in graph) {
        Iterator<EdgeType> it2 = EdgeIterator<VertexType, EdgeType>(graph,
            vertex: vertex, source: false);

        while (it2.moveNext()) {
          final edge = it2.current;
          if (edge.edgeIterationIndex == graph.edgeIterationIndex) {
            continue;
          }
          edge.edgeIterationIndex = graph.edgeIterationIndex;
          edges.add(edge);
        }

        edgesIterator = edges.iterator;
      }
    } else {
      if (source) {
        for (final Pair<EdgeType, VertexType> pev in graph.list[vertex.id]) {
          edges.add(pev.first);
        }
        edgesIterator = edges.iterator;
      } else {
        for (final Pair<EdgeType, VertexType> pev
            in graph.inverseList[vertex.id]) {
          edges.add(pev.first);
        }
        edgesIterator = edges.iterator;
      }
    }
  }

  Iterator<EdgeType> edgesIterator;
  final ListGraph graph;

  @override
  EdgeType get current => edgesIterator.current;

  @override
  bool moveNext() {
    return edgesIterator.moveNext();
  }
}

class EdgeIterabel<VertexType extends BaseVertex,
    EdgeType extends BaseEdge<VertexType>> extends Iterable<EdgeType> {
  final EdgeIterator<VertexType, EdgeType> _iterator;

  EdgeIterabel(ListGraph graph)
      : _iterator = EdgeIterator<VertexType, EdgeType>(graph);

  Iterator<EdgeType> get iterator => _iterator;
}
