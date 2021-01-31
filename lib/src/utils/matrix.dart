class Matrix {
  final List<List<double>> _values;

  Matrix._(this._values);

  factory Matrix(int x1, int x2) {
    return Matrix._(List.generate(x1, (index) => []));
  }

  List<double> operator [](int m) => _values[m];
}
