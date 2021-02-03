import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:graph/graph.dart';
import 'package:graph/src/ui/graph_model.dart';
import 'package:graph/src/ui/paint_delegate.dart';

class GraphRenderer {
  GraphRenderer(this.graph)
      : graphModel = GraphModel(graph.toList(), graph.edges);

  final Graph graph;
  GraphModel graphModel;

  Size _size = Size(400, 400);

  void Function(PaintDelegate delegate) rebuild;

  set size(Size newSize) {
    _size = newSize;
    //build();
  }

  Size get size => _size;

  void updateModel() {
    graphModel = GraphModel(graph.toList(), graph.edges.toList());
  }

  // ignore: non_constant_identifier_names
  double _f_a(double x, double k) => sqrt(x) / k;

  // ignore: non_constant_identifier_names
  double _f_r(double x, double k) => sqrt(k) / x;

  double temperatur(int x, int iterations) => -0.1 / iterations * x + 0.1;

  void build() {
    final height = size.height;
    final width = size.width;
    final iterations = 1;
    final area = height * width;
    final k = sqrt(area / graph.getVerticesCount());

    for (var i = 0; i < iterations; i++) {
      var t = temperatur(i, iterations);
      for (final v in graph) {
        print('vertex loop 1');
        graph[v.id].disp = GPoint.zero();

        for (final u in graph) {
          print('vertex loop 2');
          if (u != v) {
            final delta = graph[v.id].pos - graph[u.id].pos;
            graph[v.id].disp += delta.normalise() * _f_r(delta.length, k);
          }
        }
      }

      for (final e in graph.edges) {
        print('edges loop');
        final delta = graph[e.source.id].pos - graph[e.target.id].pos;
        graph[e.source.id].disp -= delta.normalise() * _f_a(delta.length, k);
        graph[e.target.id]..disp += delta.normalise() * _f_a(delta.length, k);
      }

      for (final v in graph) {
        print('vertex position loop');
        graph[v.id].pos += (graph[v.id].disp / graph[v.id].disp.length) *
            min(graph[v.id].disp.length, t);
        graph[v.id].pos.x = min(width / 2, max(-width / 2, graph[v.id].pos.x));
        graph[v.id].pos.y =
            min(height / 2, max(-height / 2, graph[v.id].pos.x));
      }
    }

    for (final v in graph) {
      print('change coodsys loop');
      graph[v.id].pos = _changeCoordSystem(v.pos);
    }
    final delegate = PaintDelegate(graph.vertices);
    print(delegate.toString());
    updateModel();

    if (rebuild != null) {
      rebuild(delegate);
    }
  }

  GPoint _changeCoordSystem(GPoint v) {
    final x = v.x + size.width / 2;
    final y = -v.y + size.height / 2;

    return GPoint(x, y);
  }
}
