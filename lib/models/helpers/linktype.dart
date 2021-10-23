enum LinkType {
  homepage,
  homework,
  onlineClassroom,
  onlineTutorium,
  script,
  professor,
  tutor,
  studygroup,
  community
}

extension LinkTypeUtil0 on int {
  LinkType toLinkType() {
    return LinkType.values[this];
  }
}

extension LinkTypeUtil1 on LinkType {
  String toStringCustom() {
    switch (this) {
      case LinkType.homepage:
        return "Homepage";
      case LinkType.homework:
        return "Homework";
      case LinkType.onlineClassroom:
        return "Online classroom";
      case LinkType.onlineTutorium:
        return "Online tutorium";
      case LinkType.script:
        return "Script";
      case LinkType.professor:
        return "Professor";
      case LinkType.tutor:
        return "Tutor";
      case LinkType.studygroup:
        return "Studygroup";
      case LinkType.community:
        return "Community";
    }
  }
}
