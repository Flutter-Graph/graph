part of graph;

/// Contains implementations of all graph features
class FullGraph
    with
        GraphItemsMixin,
        UndirectedGraphMixin,
        UndirectedValueGraphMixin,
        DirectedGraphMixin,
        DirectedValueGraphMixin,
        GraphGetMixin,
        GraphLayoutMixin,
        IterableMixin
    implements Graph {}
