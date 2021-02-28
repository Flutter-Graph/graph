part of graph;

class _Tuple2<T> {
  final T a;
  final T b;

  _Tuple2(this.a, this.b);

  /// return `fn(a, b)`
  R toDo<R>(R Function(T a, T b) fn) => fn(a, b);

  /// `x = toDo(a)` and `y = toDo(b)` then return `Tuple2(x, y)`
  _Tuple2<R> map<R>(R Function(T v) toDo) => _Tuple2(toDo(a), toDo(b));

  /// `x = toDo(a, b)` and `y = toDo(b, a)` then return `Tuple2(x, y)`
  _Tuple2<R> mutual<R>(R Function(T f, T t) toDo) =>
      _Tuple2(toDo(a, b), toDo(b, a));

  /// return `Tuple2(Tuple2(a, b), Tuple2(a, b))`
  _Tuple2<_Tuple2<T>> fork() => _Tuple2(this, this);

  /// return `Tuple2(Tuple2(a, a), Tuple2(b, b))`
  _Tuple2<_Tuple2<T>> pack() => _Tuple2(_Tuple2(a, a), _Tuple2(b, b));

  /// `x = doa(a)` and `y = dob(b)` then return `Tuple2(x, y)`
  _Tuple2<R> allDo<R>(R Function(T a) doa, R Function(T b) dob) =>
      _Tuple2(doa(a), dob(b));

  /// `x = toDo(a)` and `y = toDo(b)` then return `Tuple2(x, y)`
  _FnTuple2<F, R> mapFn<F extends Function, R>(
          R Function(F) Function(T v) toDo) =>
      _FnTuple2(toDo(a), toDo(b));

  /// when fn -> true return Some(this) else None
  _Tuple2<T>? where(bool Function(_Tuple2<T> t) fn) =>
      fn(this) ? this : null;

  /// make effect
  _EffectTuple2<T> get effect => _EffectTuple2(this);
}

class _FnTuple2<F extends Function, R> {
  final R Function(F) a;
  final R Function(F) b;

  _FnTuple2(this.a, this.b);

  _Tuple2<R> allDo(F doa, F dob) => _Tuple2(a(doa), b(dob));
}

class _EffectTuple2<T> {
  final _Tuple2<T> t;

  _EffectTuple2(this.t);

  /// `fn(a, b)`
  _EffectTuple2<T> toDo(Function(T a, T b) fn) {
    fn(t.a, t.b);
    return this;
  }

  /// `toDo(a)` then `toDo(b)`
  _EffectTuple2<T> map(Function(T v) toDo) {
    toDo(t.a);
    toDo(t.b);
    return this;
  }

  /// `toDo(a, b)` then `toDo(b, a)`
  _EffectTuple2<T> mutual(Function(T f, T t) toDo) {
    toDo(t.a, t.b);
    toDo(t.b, t.a);
    return this;
  }

  /// `doa(a)` then `dob(b)`
  _EffectTuple2<T> allDo(Function(T a) doa, Function(T b) dob) {
    doa(t.a);
    dob(t.b);
    return this;
  }

  /// end effect
  _Tuple2<T> get end => t;
}

/// `a -> b -> a || b`
bool _or(bool a, bool b) => a || b;

bool _and(bool a, bool b) => a && b;


/// Gets the id if a [Node] is passed
/// Otherwise it returns the passed [String] or [null] if var is not of type [String] or [Node]
String? _getKey(val) {
  if (val is Node) {
    return val.id;
  } else if(val is String) {
    return val;
  }
  return null;
}



