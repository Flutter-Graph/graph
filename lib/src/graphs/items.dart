part of graph;

/// Basic graph node collection
abstract class GraphItems implements Iterable {
  /// Add a Node to Graph
  ///
  /// Return false when there is such a node
  bool add(val);

  /// Determine if there is such a node in graph
  bool has(val);

  /// If there is such a node, remove it
  ///
  /// Return false when there is no such node
  bool remove(val);

  /// Get all nodes
  Iterable get items;

  /// Get the number of nodes
  @override
  int get length;

  /// Get all nodes
  @override
  Iterator get iterator;

  /// The [flatMap()] method first maps each element using a mapping function, then flattens the result into a new array
  // ignore: use_function_type_syntax_for_parameters
  Iterable<R> flatMap<R>(Iterable<R> f(item));

  /// set the VectorPosition of an node. Returns false if there is no such node
  bool setPos(val, VectorPosition pos);

}

/// Mixing of implementations of [GraphItems]
mixin GraphItemsMixin implements GraphItems, Iterable {
  final Map<dynamic, _Node> _map = {};
  final Map<_Node, dynamic> _node_to_val = {};
  final Map<dynamic, VectorPosition> _node_to_pos = {};

  _Node _map_add_or_get(key, _Node Function() def) {
    if (_map.containsKey(key)) return _map[key];
    final val = def();
    _map[key] = val;
    _node_to_val[val] = key;
    _node_to_pos[key] = VectorPosition.zero;
    return val;
  }

  @override
  bool add(val) {
    if (_map.containsKey(val)) {
      return false;
    }
    final node = _Node();
    _map[val] = node;
    _node_to_val[node] = val;
    _node_to_pos[val] = VectorPosition.zero;
    return true;
  }

  @override
  bool has(val) {
    return _map.containsKey(val);
  }

  @override
  bool remove(val) {
    if (_map.containsKey(val)) {
      final node = _map[val];
      for (var from in node.from) {
        from.to.remove(node);
      }
      for (var to in node.to.keys) {
        to.from.remove(node);
      }
      _node_to_val.remove(node);
      _map.remove(val);
      _node_to_pos.remove(val);
      return true;
    }
    return false;
  }

  @override
  bool setPos(val, VectorPosition pos) {
    if (!_map.containsKey(val)) {
      return false;
    }
    _node_to_pos[val] = pos;
    return true;
  }

  @override
  Iterable get items => _map.keys;

  @override
  int get length => _map.length;

  @override
  Iterator get iterator => items.iterator;

  @override
  Iterable<R> flatMap<R>(Iterable<R> Function(dynamic item) f) sync* {
    for (var item in items) {
      yield* f(item);
    }
  }
}
