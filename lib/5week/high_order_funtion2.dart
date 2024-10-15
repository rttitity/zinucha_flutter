Function createMultiplier(int multiplier) {
  return (int value) => value * multiplier;
}

void main() {
  var double = createMultiplier(2);
  var triple = createMultiplier(3);

  print(double(5)); // 10
  print(triple(5)); // 15
}
