import '../edge.dart';
import '../vertex.dart';

abstract class GraphListener{
    void vertexAdded(Vertex v);

    void vertexRemoved(Vertex v);

    void edgeAdded(Edge e);

    void edgeRemoved(Edge e);

    void graphCleared();

    void repaintGraph();
}