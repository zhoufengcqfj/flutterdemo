
void main() {
  String info = "a\nb";
  print("......");
  print(info);
  print("......");

}
String getComment(String a) {
  String result = '';
  a.split("\n").forEach((element) {
    result += "///" + element;
    result += "\n";
  });
  return result.substring(0, result.length - 1);
}