class MinMaxValue {
  final int _minValue;
  final int _maxValue;

  const MinMaxValue({
    required int minValue,
    required int maxValue,
  })  : _minValue = minValue,
        _maxValue = maxValue;

  int get minValue => _minValue;

  int get maxValue => _maxValue;
}
