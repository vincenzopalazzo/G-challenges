class ProjectScheduler {
  final List<Contributor> contributors;
  final List<Project> projects;
  List<Project> finalProject = List.empty(growable: true);

  ProjectScheduler(this.contributors, this.projects);
}

class Contributor {
  final String name;
  final List<Skill> skills;

  Contributor(this.name, this.skills);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contributor &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          skills == other.skills;

  @override
  int get hashCode => name.hashCode ^ skills.hashCode;

  bool canMentor(Skill skill) {
    for (var mSkill in skills) {
      if (skill == mSkill) {
        return true;
      }
    }
    return false;
  }

  void updateSkill(Skill skill) {
    for (var element in skills) {
      if (element.name == skill.name) {
        element.level++;
      }
    }
  }

  @override
  String toString() {
    return 'Contributor{name: $name, skills: $skills}';
  }
}

class Skill {
  final String name;
  int level;

  Skill(this.name, this.level);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Skill{name: $name, level: $level}';
  }
}

class Project {
  final String name;
  final int duration;
  final int award;
  final int bestBefore;
  final List<Skill> roles;
  Map<Skill, Contributor> contributorRoles = {};
  Set<Contributor> contributors = {};

  Project(this.name, this.duration, this.award, this.bestBefore, this.roles);

  void addContributor(Skill skill, Contributor contributor) {
    contributorRoles[skill] = contributor;
    contributors.add(contributor);
  }

  bool isInside(Contributor contributor) {
    return contributors.contains(contributor);
  }

  bool isComplete() {
    return roles.length == contributorRoles.length;
  }

  List<Skill> roleMissing() {
    return [];
  }

  @override
  String toString() {
    return 'Project{name: $name, duration: $duration, award: $award, bestBefore: $bestBefore, roles: $roles, contributorRoles: $contributorRoles, contributors: $contributors}';
  }
}
