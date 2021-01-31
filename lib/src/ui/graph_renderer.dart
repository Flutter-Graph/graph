import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:graph/graph.dart';
import 'package:graph/src/ui/graph_model.dart';
import 'package:graph/src/ui/paint_delegate.dart';

class GraphRenderer implements VertexListener, EdgeListener, GraphListener {
  final Graph graph;
  GraphModel graphModel;
  Function(PaintDelegate delegate) rebuild;
  Size _size = Size(100, 100);

  GraphRenderer(this.graph)
      : graphModel = GraphModel(graph.toList(), graph.edges.toList());

  void setGraph() {
    graph.addGraphListener(this);
    for (Vertex v in graph) {
      v.setVertexListener(this);
    }
    for (Edge e in graph.edges) {
      e.setEdgeListener(this);
    }
  }

  set size(Size newSize) {
    _size = newSize;
    markAllRepaint();
    build();
  }

  Size get size => _size;

  void updateModel() {
    graphModel = GraphModel(graph.toList(), graph.edges.toList());
  }

  void markEdgeRepaint(Edge edge) => graphModel.markEdgeRepaint;
  void markVertexRepaint(Vertex vertex) => graphModel.markVertexRepaint;
  void markAllRepaint() => graphModel.markAllRepaint();

  // ignore: non_constant_identifier_names
  double _f_a(double x, double k) => sqrt(x) / k;

  // ignore: non_constant_identifier_names
  double _f_r(double x, double k) => sqrt(k) / x;

  double temperatur(int x, int iterations) => -0.1 / iterations * x + 0.1;

  void build() {
    final length = size.height;
    final width = size.width;
    final iterations = 10;
    final area = length * width;
    final k = sqrt(area / graph.getVerticesCount());

    for (int i = 0; i < iterations; i++) {
      double t = temperatur(i, iterations);
      for (final Vertex v in graph) {
        v.disp = GPoint.zero();

        for (final Vertex u in graph) {
          if (u != v) {
            final GPoint delta = v.pos - u.pos;
            v.disp += delta.normalise() * _f_r(delta.length, k);
          }
        }
      }

      for (final Edge e in graph.edges) {
        final delta = graph[e.source.id].pos - graph[e.target.id].pos;
        graph[e.source.id].disp -= delta.normalise() * _f_a(delta.length, k);
        graph[e.target.id]..disp += delta.normalise() * _f_a(delta.length, k);
      }

      for (final Vertex v in graph) {
        v.pos += (v.disp / v.disp.length) * min(v.disp.length, t);
        v.pos.x = min(width / 2, max(-width / 2, v.pos.x));
        v.pos.y = min(length / 2, max(-length / 2, v.pos.x));
      }
    }
    final delegate = PaintDelegate(graph.vertices, graphModel.vertecies, null);
    updateModel();
    return rebuild(delegate);
  }

  @override
  void edgeAdded(Edge e) {
    build();
  }

  @override
  void edgeRemoved(Edge e) {
    build();
  }

  @override
  void graphCleared() {
    build();
  }

  @override
  void repaintEdge(Edge edge) {
    build();
  }

  @override
  void repaintGraph() {
    build();
  }

  @override
  void repaintVertex(Vertex vertex) {
    build();
  }

  @override
  void vertexAdded(Vertex v) {
    build();
  }

  @override
  void vertexRemoved(Vertex v) {
    build();
  }
}
