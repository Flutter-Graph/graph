import 'package:graph/src/base_vertex.dart';
import 'package:graph/src/base_vertex_properties.dart';
import 'package:graph/src/ui/gpoint.dart';
import 'package:graph/src/ui/vertex_listener.dart';

class Vertex extends BaseVertex {
  Vertex(BaseVertexProperties prop) : super(prop) {
    _isSelected = false;
    changed = true;
  }

  VertexListener view;
  GPoint pos;
  GPoint disp;
  bool _isSelected;
  bool changed;

  void setVertexListener(VertexListener listener) {
    view = listener;
  }

  void setMarked(bool mark) {
    super.mark = mark;
    fireModelListenerChanged();
  }

  void fireModelListenerChanged() {
    if (view != null) {
      repaint();
    }
  }

  void setLocation(GPoint p) {
    this.pos = p;
    fireModelListenerChanged();
  }

  set isSelected(bool s) {
    _isSelected = s;
    fireModelListenerChanged();
  }

  get isSelected => _isSelected;

  void repaint() => view.repaintVertex(this);
}
