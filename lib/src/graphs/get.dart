part of graph;

/// The part used to get the value of the edge in the graph
abstract class GraphGet implements GraphItems {
  /// Get the value on the specified edge
  /// If the given from and to is of type [Node] and unknown, the node will be inserted into the graph
  /// If the given from and to is of type [String] and a key of a known [Node] the corresponding edge is returned
  /// If the given type doesnt match any of these criteria a new [Node] with [Node.value] is created
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]

  Edge? getLink(from, to, {List anyTags, List allTags});

  Node get(val);

  bool update(Node node);
}

/// Mixing of implementations of [GraphGet]
mixin GraphGetMixin on GraphItemsMixin implements GraphGet {
  @override
  Edge? getLink(from, to, {List anyTags = const [], List allTags = const []}) {
    assert(from != null && to != null, 'from and to must not be null');

    final f = _getOrAdd(from);
    final t = _getOrAdd(to);

    if (f.hasTo(t)) {
      if (anyTags.isEmpty && allTags.isEmpty) {
        return f.to[t];
      }
      if (f.hasTagAny(t, anyTags) && f.hasTags(t, allTags)) {
        return f.to[t];
      }
    }
    return null;
  }

  @override
  Node get(val) {
    return _getOrAdd(val);
  }

  @override
  bool update(Node node) {
    if (!has(node)) {
      return false;
    }
    items.singleWhere((element) => element.id == node.id)
      ..size = node.size
      ..position = node.position;
    return true;
  }
}
