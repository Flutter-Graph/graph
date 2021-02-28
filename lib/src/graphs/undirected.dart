part of graph;

/// Undirected graph, Can create an edge between 2 nodes
abstract class UndirectedGraph extends GraphItems {
  factory UndirectedGraph() = FullGraph;

  /// create an link between 2 nodes
  ///
  /// Optional [tags] for setting tags
  /// Overrides any existing undirected Link
  Edge link(a, b, {List tags, value});

  /// Determine if there is an link between 2 nodes
  /// if edgeType is [EdgeType.directed] the direction does not matter
  ///
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  bool hasLink(a, b, {List anyTags, List allTags, EdgeType edgeType});

  /// Remove the link between 2 nodes
  ///
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  bool unLink(a, b, {List anyTags, List allTags});

  /// Get all neighbours of this node
  ///
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  Iterable<Node> neighbours(val, {List anyTags, List allTags,EdgeType edgeType});

  /// Get all edges of the graph
  /// Undirected edges are seen as two edges one in each direction
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  Iterable<Edge> links({List anyTags, List allTags});

  /// Get all edges in the graph
  Iterable<Edge> get edges;
}

/// Mixing of implementations of [UndirectedGraph]
mixin UndirectedGraphMixin on GraphItemsMixin implements UndirectedGraph {
  @override
  Edge link(a, b, {List tags = const [], value}) {
    final linkId = Uuid().v4();

    final tuple = _Tuple2(a, b)
        .map((v) => _getOrAdd(v))
        .effect
        .mutual((f, t) => f.setFrom(t))
        .mutual((f, t) => f.setTo(t,
            value: value, tags: tags, sharedId: linkId, directed: false))
        .t;

    return tuple.a.to[tuple.b]!;
  }

  @override
  bool hasLink(a, b, {List anyTags = const [], List allTags = const [], EdgeType edgeType = EdgeType.all}) {
    final comparison = edgeType == EdgeType.undirected ? _and : _or;
    return _Tuple2(a, b)
        .map((v) => _getOrAdd(v))
        .mutual((f, t) =>
            f.hasTo(t, allTags: allTags, anyTags: anyTags, edgeType: edgeType))
        .toDo(comparison);
  }

  @override
  bool unLink(a, b, {List anyTags = const [], List allTags = const []}) {
    if (!has(a) || !has(b)) {
      return false;
    }

    final tupleWhere = _Tuple2(a, b).map((v) => _getOrAdd(v)).where((t) => t
        .mutual((f, t) =>
            f.hasTo(t, anyTags: anyTags, allTags: allTags, edgeType: EdgeType.undirected))
        .toDo(_or));
    if (tupleWhere != null) {
      return tupleWhere
          .fork()
          .mapFn<bool Function(Node, Node), _Tuple2<bool>>(
              (t) => (fn) => t.mutual(fn))
          .allDo((f, t) => f.unsetTo(t), (f, t) => f.unsetFrom(t))
          .map((t) => t.toDo(_or))
          .toDo(_and);
    }
    return false;
  }

  @override
  Iterable<Node> neighbours(val,
      {List anyTags = const [], List allTags = const [], EdgeType edgeType = EdgeType.all}) {
    final _v = _getOrAdd(val);
    if (anyTags.isEmpty && allTags.isEmpty && edgeType == EdgeType.all) {
      return _v.to.keys;
    } else {
      return _v.to.values
          .where((n) => _v.hasTo(n.target, anyTags: anyTags, allTags: allTags,edgeType: edgeType))
          .map((e) => e.target);
    }
  }

  @override
  Iterable<Edge> links(
      {List anyTags = const [], List allTags = const [], EdgeType edgeType = EdgeType.all}) sync* {
    for (final node in this) {
      yield* node.to.values.where((e) {
        if(!e.isType(edgeType)){
          return false;
        }
        if (anyTags.isEmpty && allTags.isEmpty) {
          return true;
        } else if (anyTags.isEmpty) {
          return e.tags.containsAll(allTags);
        } else if (allTags.isEmpty) {
          return e.tags.any((e) => anyTags.contains(e));
        } else {
          return e.tags.any((e) => anyTags.contains(e)) &&
              e.tags.containsAll(allTags);
        }
      });
    }
  }

  @override
  Iterable<Edge> get edges => expand((e) => e.to.values);
}
