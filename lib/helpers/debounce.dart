import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer <T> {//clase generica

  Debouncer({
    required this.duration,//tiempo de espera para valor
    this.onValue//metodo que se dispara  cuando tenga valor
  });

  final Duration duration;//propiedad

  void Function(T value)? onValue;

  T? _value;//
  Timer? _timer;//opcional funcon de control

  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();//si hay valor e camnsela
    _timer = Timer(duration, () => onValue!(_value!));//cuando se cumpla Tie se llama valor
  }
}