part of graph;

/// Basic graph node collection
abstract class GraphItems implements Iterable<Node> {
  /// Add a Node to Graph
  /// If val is not of type [Node] a new [Node] with [Node.value] val is created
  /// Returns the id of the Node
  String add(val);

  /// Determine if there is such a node in graph
  /// val can be a String key as well as a Node
  /// Returns false if the passed key is invalid
  bool has(val);

  /// If there is such a node, remove it.
  /// Return false when there is no such node
  /// val can be a dynamic key as well as a Node
  bool remove(id);

  /// Iterable of all Nodes
  Iterable<Node> get items;

  /// Get the number of nodes
  @override
  int get length;

  /// Iterator of all Nodes
  @override
  Iterator<Node> get iterator;

  /// The [flatMap()] method first maps each element using a mapping function, then flattens the result into a new array
  Iterable<R> flatMap<R>(Iterable<R> Function(Node node) f);

  /// Clears the whole graph
  void clear();


}

/// Mixing of implementations of [GraphItems]
mixin GraphItemsMixin implements GraphItems, Iterable<Node> {
  final Map<String, Node> _map = {};

  //////////////////////////////////////////////////////////////////////////////
  // External Methods
  //////////////////////////////////////////////////////////////////////////////

  @override
  String add(val) {
    return _getOrAdd(val).id;
  }

  @override
  bool has(val) {
    final key = _getKey(val);
    return _map.containsKey(key);
  }

  @override
  bool remove(val) {
    final key = _getKey(val);
    if (_map.containsKey(key)) {
      final node = _map[key]!;
      for (var from in node.from) {
        from.to.remove(node);
      }
      for (var to in node.to.keys) {
        to.from.remove(node);
      }
      _map.remove(key);
      return true;
    }
    return false;
  }

  @override
  Iterable<Node> get items => _map.values;

  @override
  int get length => _map.length;

  @override
  Iterator<Node> get iterator => items.iterator;

  @override
  Iterable<R> flatMap<R>(Iterable<R> Function(Node item) f) sync* {
    for (var item in items) {
      yield* f(item);
    }
  }

  @override
  void clear(){
    _map.clear();
  }


  //////////////////////////////////////////////////////////////////////////////
  // Internal methods
  //////////////////////////////////////////////////////////////////////////////

  /// Gets a node if the key exists or if val is an existing [Node].
  /// If [Node] doesn't exists, the key is invalid or val has another Runtime-Type a new Node will be created
  Node _getOrAdd(val) {
    if (has(val)) {
      return _map[_getKey(val)]!;
    } else {
      if(val is Node){
        _map[val.id] = val;
        return val;
      }else if (val is NodeData){
        final node = Node.fromData(val);
        _map[node.id] = node;
        return node;
      }
      else{
        final node = Node.fromVal(val);
        _map[node.id] = node;
        return node;
      }

    }
  }
}
