class Project {
  final String title;

  Project({this.title});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['title'] = title;
    return map;
  }

  factory Project.fromJson(Map<String, dynamic> recordJson) {
    return Project(
      title: recordJson["title"],
    );
  }

  @override
  String toString() {
    return "project: title:$title";
  }
}
