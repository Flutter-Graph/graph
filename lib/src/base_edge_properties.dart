class BaseEdgeProperties {
  int weight;
  int color;
  bool mark;

  BaseEdgeProperties(this.weight, this.color, this.mark);

  bool equals(BaseEdgeProperties o) {
    return weight == o.weight && color == o.color;
  }
}
