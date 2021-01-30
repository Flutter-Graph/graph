import 'dart:collection';

import 'package:graph/src/base_vertex.dart';

import 'failures/exceptions.dart';

class Path<VertexType extends BaseVertex> with IterableMixin<VertexType> {
  final List<BaseVertex> vertices = [];

  void insert(VertexType vertex, {int index}) {
    if (vertices.contains(vertex))
      throw InvalidVertexException("Duplicate vertex in path");
    if (index != null) {
      vertices.insert(index, vertex);
    } else {
      vertices.add(vertex);
    }
  }

  @override
  Iterator<VertexType> get iterator => vertices.iterator;

  operator [](int index) {
    return vertices[index];
  }

  get size => vertices.length;
}
