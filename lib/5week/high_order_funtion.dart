void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  List<int> squaredNumbers = processList(numbers, (number) => number * number);
  print(squaredNumbers); // [1, 4, 9, 16, 25]
}

List<int> processList(List<int> list, int Function(int) operation) {
  List<int> result = [];
  for (var item in list) {
    result.add(operation(item));
  }
  return result;
}
