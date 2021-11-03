Set linkType = {
  "homepage",
  "homework",
  "onlineClassroom",
  "onlineTutorium",
  "script",
  "professor",
  "tutor",
  "studygroup",
  "community",
};

extension ToHumanReadable on String {
  static final Map _dictionary = {
    "homepage": "homepage",
    "homework": "homework",
    "onlineClassroom": "online classroom",
    "onlineTutorium": "online tutorium",
    "script": "script",
    "professor": "professor",
    "tutor": "tutor",
    "studygroup": "study group",
    "community": "community",
  };

  String toHumanReadable() {
    return _dictionary[this];
  }
}
