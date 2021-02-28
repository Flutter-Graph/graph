part of graph;

/// Contains implementations of all graph features
class FullGraph
    with
        GraphItemsMixin,
        UndirectedGraphMixin,
        DirectedGraphMixin,
        GraphGetMixin,
        IterableMixin<Node>
    implements Graph {}
