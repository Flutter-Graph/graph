import 'dart:collection';

import 'package:graph/src/base_edge.dart';
import 'package:graph/src/base_vertex.dart';
import 'package:graph/src/utils/matrix.dart';

abstract class BaseGraph<VertexType extends BaseVertex,
    EdgeType extends BaseEdge<VertexType>> with IterableMixin<VertexType> {
  //Retuns the nuber of vertices in the graph
  int getVerticesCount();

  //insert an edge in the graph
  void insertEdge(EdgeType newEdge);

  //Removes all edges between two vertices
  void removeAllEdges(VertexType source, VertexType target);

  //Removes an edge form the graph
  void removeEdge(EdgeType edge);

  //Returns a list of all edges wich connect two vertices
  List<EdgeType> getEdges(VertexType source, VertexType target);

  //Returns true if two vertices are connected
  bool isConnected(VertexType source, VertexType target);

  //Returns the weight of the edge between two vertices
  int weightOfEdge(VertexType source, VertexType target);

  //Insert a new vertex in the graph
  void insertVertex(VertexType newVertex);

  //Remove vertex and all it's connexted edges
  void removeVertex(VertexType vertex);

  //Get number of edges going to vertex
  int getInDegree(VertexType vertex);

  //Get number of edges going from vertex
  int getOutDegree(VertexType vertex);

  //Adjacency Matric as Jama Matrix
  Matrix getAdjacencyMatrix();

  Matrix getWeightedAdjacencyMatrix();

  bool isDirected();

  //returns true if Graph contains given vertex
  bool containsVertex(VertexType vertex);

  //should be called before operating on any vertex coming form "outside"
  void checkVertex(VertexType vertex);

  //Returns list of vertices upcasted to BaseVertex
  List<BaseVertex> getVertexList();

  //Returns list of list of int where represent a simple adjcency list
  List<List<int>> getEdgeList();

  //clears the graph
  void clear();

  set directed(bool isDirected);

  //If 0, indicated that the graph is not a subgraph,
  //greater than 0 indicated that this is a subgraph with the given id
  int subgraphIndex = 0;

  bool isSubgraph = false;

  BaseGraph<VertexType, EdgeType> superGraph;

  void registerSubgraph(BaseGraph<VertexType, EdgeType> superGraph) {
    isSubgraph = true;
    this.superGraph = superGraph;
    superGraph.informVertices();
  }

  void informVertices() {
    if (isSubgraph) {
      superGraph.informVertices();
    }
    for (VertexType v in this) {
      v.informNewSubgraph();
    }
  }

  int getNewSubgraphIndex() {
    if (isSubgraph) {
      return superGraph.getNewSubgraphIndex();
    }
    int lastSubgraphIndex = 0;
    return lastSubgraphIndex + 1;
  }

  int getId(VertexType v) {
    if (subgraphIndex != 0) {
      return v.getSubgraphId(subgraphIndex);
    }
    return v.id;
  }

  int getEdgesCount();

  Iterable<EdgeType> edges({VertexType v}) {
    //TODO
    throw UnimplementedError();
  }

  //returns the number of edges connected to the vertex
  int getDegree(VertexType vertex) {
    return isDirected()
        ? getInDegree(vertex) + getOutDegree(vertex)
        : getInDegree(vertex);
  }

  //Returns an iterable object which can be iterated trough all neighbours
  Iterable<VertexType> getNeighbors(VertexType vertex) {
    //TODO
    throw UnimplementedError();
  }

  //Returns an Iterable which can iterated on all vertices of the graph
  Iterable<VertexType> verticesIterable() {
    return this;
  }

  //Returns an iterable object which can be iterated trough all Backneighbours

   Iterable<VertexType> getBackNeighbors(VertexType vertex) {
    //TODO
    throw UnimplementedError();
  }
}
