/// @Author 90196
/// @DateTime 2021/6/9 10:07
/// @Description: 集合扩展
extension ListX<T> on List {

  List<T> filter(bool Function(T) test) {
    var result = List<T>.empty(growable: true);
    this.forEach((element) {
      if (test(element)) {
        result.add(element);
      }
    });
    return result;
  }
}

extension SetX<T> on Set {

  Set<T> filter(bool Function(T) test) {
    var result = Set<T>();
    this.forEach((element) {
      if (test(element)) {
        result.add(element);
      }
    });
    return result;
  }
}