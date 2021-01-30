class BaseVertexProperties {
  int color;
  bool mark;

  BaseVertexProperties({this.color, this.mark});

  bool equals(BaseVertexProperties o) {
    return color == o.color;
  }
}
