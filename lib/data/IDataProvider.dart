abstract class IDataProvider {
  Future<List<Map<String, String>>> loadExcel(String filePath);

  deleteFile(String filePath) {}
}
