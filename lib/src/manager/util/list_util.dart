class ListUtil {
  static List<List<int>> splitList(List<int> originalList, int chunkSize) {
    List<List<int>> result = [];
    for (int i = 0; i < originalList.length; i += chunkSize) {
      int end = (i + chunkSize < originalList.length) ? i + chunkSize : originalList.length;
      result.add(originalList.sublist(i, end));
    }
    return result;
  }
}