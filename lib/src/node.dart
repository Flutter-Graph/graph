part of graph;

class Node {
  final String id;
  NodeData _value;
  final Map<Node, Edge> to = {};
  final Set<Node> from = {};

  Node._(value)
      : _value = value,
        id = Uuid().v4();

  factory Node.fromVal(val) {
    return Node._(DefaultNodeData(val));
  }

  factory Node.fromData(NodeData data) {
    return Node._(data);
  }

   bool? _labelVisible;
  bool get labelVisible {
    assert(_labelVisible != null, 'labelVisible can not be accessed before it was initialized');
    return _labelVisible!;
  }
  set labelVisible(bool visible) {
    _labelVisible = visible;
  }

  double? _radius;
  double get radius {
    assert(_radius != null, 'radius can not be accessed before it was initialized');
    return _radius!;
  }
  set radius(double radius) {
    _radius = radius;
  }

  dynamic _position;
  dynamic get position {
    assert(_position != null, 'Position can not be accessed before it was initialized');
    return _position;
  }
  set position(dynamic position) {
    assert(position != null, 'Position can not be initialized with null');
    _position = position;
  }

  dynamic _size;
  dynamic get size {
    assert(_size != null, 'Size can not be accessed before it was initialized');
    return _size;
  }
  set size(dynamic size) {
    assert(size != null, 'Size can not be initialized with null');
    _size = size;
  }



  dynamic get value => _value.value;

  String get label => _value.label ?? id;

  double get height => size.height;

  double get width => size.width;

  double get x => position.dx;

  double get y => position.dy;


  @override
  bool operator ==(Object other) {
    if (other is Node) {
      return id == other.id;
    }
    return false;
  }

  bool get hasEdges => to.isNotEmpty || from.isNotEmpty;

  bool hasTags(Node node, List tags) {
    if (tags.isEmpty) return false;
    return to[node]?.tags.containsAll(tags) ?? false;
  }

  bool hasTagAny(Node node, List tags) {
    if (tags.isEmpty) return false;
    return tags.any((tag) => to[node]?.tags.contains(tag) ?? false);
  }

  bool hasTo(Node node,
      {List anyTags = const [],
      List allTags = const [],
      EdgeType edgeType = EdgeType.all}) {
    if (to.containsKey(node)) {
      if (!to[node]!.isType(edgeType)) {
        return false;
      }
      if (anyTags.isEmpty && allTags.isEmpty) {
        return true;
      }
      if (anyTags.isEmpty) {
        return hasTags(node, allTags);
      }
      if (allTags.isEmpty) {
        return hasTagAny(node, anyTags);
      }
      return hasTagAny(node, anyTags) && hasTags(node, allTags);
    }
    return false;
  }

  bool unsetTo(Node node) {
    return to.remove(node) != null;
  }

  bool unsetFrom(Node node) {
    return from.remove(node);
  }

  bool hasFrom(Node node) {
    return from.contains(node);
  }

  void setFrom(Node node) {
    from.add(node);
  }

  void setTo(Node node,
      {value, List tags = const [], directed = true, String? sharedId}) {
    to[node] =
        Edge(this, node, directed: directed, sharedId: sharedId, value: value)
          ..tags.addAll(tags);
  }

  @override
  String toString() => '''id: $id \n value: $value''';
}

abstract class NodeData {
  String? get label;

  dynamic get value;
}

class DefaultNodeData extends NodeData {
  @override
  dynamic value;

  DefaultNodeData([this.value]);

  @override
  String? get label => null;
}
