part of graph;

abstract class GraphLayout implements GraphGet {
  ///return the layout of each node + edges
  Map<dynamic, VectorPosition> layout();

  bool get isConnected;
}

/// Mixin implementation of [GraphLayout]
mixin GraphLayoutMixin on GraphGetMixin
    implements GraphLayout, UndirectedGraph, DirectedGraph {
  final Map<dynamic, VectorPosition> _node_to_dis = {};

  @override
  Map<dynamic, VectorPosition> layout(
      {int iter = 100,
      double kOptimal = 40000,
      double scale = 0.5,
      double gravity = 0.05}) {
    final iterations = iter;
    final k = kOptimal;

    final _layout = <dynamic, VectorPosition>{};


      for (var i = 0; i < iterations; i++) {
        var t = temperatur(i, iterations, scale);
        _node_to_dis.clear();

        for (final v in items) {
          if (getPos(v).val == VectorPosition.zero) {
            _addPos(v, VectorPosition(randomNotNull(5), randomNotNull(5)));
          }

          final pos = getPos(v).val;
          _addDis(v, -pos * gravity);

          if (i == 0) {
            print('$v: ${getPos(v).val}');
          }

          for (final u in items) {
            if (u != v) {
              if (getPos(v).val == getPos(u).val) {
                setPos(u, VectorPosition(randomNotNull(5), randomNotNull(5)));
              }
              final delta = getPos(v).val - getPos(u).val;
              _addDis(v, delta.normalise * _f_r(delta.length, k));
            }
          }
        }

        for (final v in items) {
          for (final e in links(v)) {
            final delta = getPos(v).val - getPos(e).val;
            _addDis(v, delta.normalise * _f_a(delta.length, k));
            _subDis(e, delta.normalise * _f_a(delta.length, k));
          }
        }

        for (final v in items) {
          final dis = _getOrAddDis(v);
          _addPos(v, ((dis / dis.length) * math.min(dis.length, t)));
        }
      }

    for (final v in items) {
      _layout.putIfAbsent(v, () => getPos(v).val.round());
    }
    return _layout;
  }

  double temperatur(int x, int iterations, scale) =>
      -scale / iterations * x + scale;

  void _setDis(dynamic key, VectorPosition vector) {
    _node_to_dis[key] = vector;
  }

  void _addDis(dynamic key, VectorPosition add) {
    _setDis(key, _getOrAddDis(key) + add);
  }

  void _subDis(dynamic key, VectorPosition add) {
    _setDis(key, _getOrAddDis(key) - add);
  }

  void _addPos(dynamic key, VectorPosition add) {
    setPos(key, getPos(key).val + add);
  }

  VectorPosition _getOrAddDis(dynamic key) {
    if (!_node_to_dis.containsKey(key)) {
      _node_to_dis.putIfAbsent(key, () => VectorPosition.zero);
    }
    return _node_to_dis[key];
  }

  @override
  bool get isConnected {
    if (length <= 1) return true;

    var connected = true;
    for (final n in _node_to_val.keys) {
      if (!n.hasEdges()) {
        connected = false;
        break;
      }
    }
    return connected;
  }

  // ignore: non_constant_identifier_names
  double _f_a(double x, double k) => math.sqrt(x) / k;

  // ignore: non_constant_identifier_names
  double _f_r(double x, double k) => math.sqrt(k) / x;
}
