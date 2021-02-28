part of graph;

/// Directed graph, can set the direction of the edge
abstract class DirectedGraph extends GraphItems {
  factory DirectedGraph() = FullGraph;

  /// Link a directed link, if [from] and [to] don't exist, they will be added
  /// If an undirected link already exists these will be returned
  /// If an directed link between both [Nodes] exists the link will be overridden
  /// Optional [tags] for setting tags
  Edge linkTo(from, to, {List tags, value});

  /// Determine if there is such a directed link
  /// 
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  bool hasLinkTo(from, to, {List anyTags, List allTags, EdgeType edgeType});

  /// Remove a directed link, but will not remove [from] and [to]
  /// 
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  bool unLinkTo(from, to, {List anyTags, List allTags});

  /// Get all links link from [val]
  /// 
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  Iterable<Edge> linksTo(id, {List anyTags, List allTags});

  /// Get all links link to [val]
  /// 
  /// (Optional) Only if it matches any of [anyTags] and matches all items in [allTags]
  Iterable<Edge> linksFrom(id, {List anyTags, List allTags});
}

/// Mixing of implementations of [DirectedGraph]
mixin DirectedGraphMixin on GraphItemsMixin implements DirectedGraph {
  @override
  Edge linkTo(from, to, {List tags = const [], value}) {

    final _f = _getOrAdd(from);
    final _t = _getOrAdd(to);

    if(_f.to.containsKey(_t)  &&_f.to[_t]!.isType(EdgeType.undirected)){
      return _f.to[_t]!;
    }

    _t.setFrom(_f);
    _f.setTo(_t, tags: tags, value: value);
    return _f.to[_t]!;
  }

  @override
  bool hasLinkTo(from, to, {List anyTags = const [], List allTags = const [],EdgeType edgeType = EdgeType.all}) {
    final _f = _getOrAdd(from);
    final _t = _getOrAdd(to);
    return _f.hasTo(_t, anyTags: anyTags, allTags: allTags,edgeType: edgeType);
  }

  @override
  bool unLinkTo(from, to, {List anyTags = const [], List allTags = const []}) {
    if (!has(from) || !has(to)) {
      return false;
    }

    final _f = _map[_getKey(from)]!;
    final _t = _map[_getKey(to)]!;
    if (_f.hasTo(_t, allTags: allTags, anyTags: anyTags,edgeType: EdgeType.directed)) {
      final a = _f.unsetTo(_t);
      final b = _t.unsetFrom(_f);
      return a || b;
    }
    return false;
  }

  @override
  Iterable<Edge> linksTo(val,
      {List anyTags = const [], List allTags = const [],EdgeType edgeType = EdgeType.all}) {
    final _v = _getOrAdd(val);

    return _v.to.values.where((n) =>
        _v.hasTo(n.target, anyTags: anyTags, allTags: allTags, edgeType: edgeType));
  }

  @override
  Iterable<Edge> linksFrom(val,
      {List anyTags = const [], List allTags = const [], EdgeType edgeType = EdgeType.all}) {
    final _v = _getOrAdd(val);

    return _v.from.map((e) => e.to[_v]!).where((e) =>
        e.source.hasTo(_v, anyTags: anyTags, allTags: allTags,edgeType: edgeType));

  }
}
