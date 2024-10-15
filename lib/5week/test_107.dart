int multiply(int no) {
  return no * 10;
}

int plus(int no) {
  return no + 10;
}

Function testFun(Function induk) {
  print('induk : ${induk(30)}');
  return multiply;
}

main(List<String> args) {
  var result = testFun(plus);
  print('result : ${result(20)}');
}
