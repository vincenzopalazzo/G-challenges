import 'package:hashd/core/solution.dart';
import 'package:hashd/2022/model.dart';

class SolutionProject extends Solution<ProjectScheduler> {
  // <C++, <2, [Anna]>>
  // O(1) -> O(1) -> O(1)
  // O(1) -> O(1) -> O(1)
  Map<String, Map<int, Set<Contributor>>> skillSet = {};

  void insertSkill(Skill skill, Contributor con) {
    if (skillSet.containsKey(skill.name)) {
      var skillCon = skillSet[skill.name]!;
      if (skillCon.containsKey(skill.level)) {
        var skillLevel = skillCon[skill.level]!;
        skillLevel.add(con);
      } else {
        skillCon[skill.level] = {con};
      }
    } else {
      skillSet[skill.name] = {
        skill.level: {con}
      };
    }
  }

  void incrementSkillContributor(Skill skill, Contributor contributor) {
    rawLog("For Skill ************* $skill");
    if (skillSet.containsKey(skill.name)) {
      var skillCon = skillSet[skill.name]!;
      if (skillCon.containsKey(skill.level)) {
        var skillLevel = skillCon[skill.level]!;
        skillLevel.remove(contributor);
      }
      if (skillCon.containsKey(skill.level + 1)) {
        var skillLevel = skillCon[skill.level + 1]!;
        contributor.updateSkill(skill);
        skillLevel.add(contributor);
      } else {
        skillCon[skill.level] = {contributor};
      }
    }
  }

  // Anna C++ = 2,
  // Proj C++ = 3;
  // >= 3
  // 3 - 1
  Contributor? getContributor(Skill skill, Map<Skill, Contributor> mentors,
      {bool stop = false}) {
    // 1 skill.lev >= contributor.level
    if (skillSet.containsKey(skill.name)) {
      var levelSkill = skillSet[skill.name]!;
      if (levelSkill.containsKey(skill.level)) {
        var tmpSkill = levelSkill[skill.level];
        return (tmpSkill != null && tmpSkill.isNotEmpty) ? tmpSkill.first : null;
      } else {
        // 2. skill - 1 == contributor.level
        if (stop != false) {
          var fakeSkill = Skill(skill.name, skill.level - 1);
          var downContributor = getContributor(fakeSkill, mentors, stop: true);
          if (downContributor != null) {
            for (var mentor in mentors.values) {
              if (mentor.canMentor(skill)) {
                return downContributor;
              }
            }
          }
        }
      }

      // 3. find any better contributor with skill >= skill level required
      for (var localLevel in levelSkill.keys) {
        if (localLevel >= skill.level) {
          var tmpSkill = levelSkill[localLevel];
          return (tmpSkill != null && tmpSkill.isNotEmpty) ? tmpSkill.first : null;
        }
      }
    }
    return null;
  }

  /// method that must implement the logic to parse the input file
  @override
  ProjectScheduler parse() {
    var scheduler = ProjectScheduler(
        List.empty(growable: true), List.empty(growable: true));
    var sizes = input!.readInts(2);
    var contributors = sizes[0];
    var projects = sizes[1];
    for (var i = 0; i < contributors; i++) {
      var contriRaw = input!.splitRawLine();
      var skills = int.parse(contriRaw[1]);
      var contributor = Contributor(contriRaw[0], List.empty(growable: true));
      for (var s = 0; s < skills; s++) {
        var rawSkill = input!.splitRawLine();
        var name = rawSkill[0];
        var level = int.parse(rawSkill[1]);
        var skill = Skill(name, level);
        contributor.skills.add(skill);
        insertSkill(skill, contributor);
      }
      scheduler.contributors.add(contributor);
    }
    rawLog("Final Skill set: $skillSet");
    rawLog(scheduler.contributors);

    for (var i = 0; i < projects; i++) {
      var projectRaw = input!.splitRawLine();
      var nameProj = projectRaw[0];
      var duration = int.parse(projectRaw[1]);
      var score = int.parse(projectRaw[2]);
      var best = int.parse(projectRaw[3]);
      var project =
          Project(nameProj, duration, score, best, List.empty(growable: true));
      var roles = int.parse(projectRaw[4]);
      for (var s = 0; s < roles; s++) {
        var rawSkill = input!.splitRawLine();
        var name = rawSkill[0];
        var level = int.parse(rawSkill[1]);
        var skill = Skill(name, level);
        project.roles.add(skill);
      }
      scheduler.projects.add(project);
    }
    rawLog(scheduler.projects);
    return scheduler;
  }

  bool match(ProjectScheduler input, List<Project> project) {
    rawLog("******* Match ********");
    bool increment = false;
    //Set<Project> toRemove = {};
    for (var project in project) {
      if (project.isComplete()) {
        continue;
      }
      for (var role in project.roles) {
        // contributor from skill (role) or from mentorship (contributorRoles)
        var contributor = getContributor(role, project.contributorRoles);
        if (contributor != null && !project.isInside(contributor)) {
          project.addContributor(role, contributor);
          // TODO missing if a contributor not available
        }
      }
      if (project.isComplete()) {
        increment = true;
        input.finalProject.add(project);

        for (var skill in project.contributorRoles.keys) {
          var contr = project.contributorRoles[skill]!;
          for (var contSkill in contr.skills) {
            if (skill.name == contSkill.name) {
              incrementSkillContributor(contSkill, contr);
            }
          }
        }
      }
    }
    rawLog("Final Skill set after match: $skillSet");
    return increment;
  }

  /// method that need to implement the logic to solve the problemi
  @override
  dynamic solve(ProjectScheduler input) {
    while (match(input, input.projects)) {}
    return input;
  }

  /// method that implement the logic to store the result
  @override
  void store(dynamic result) {
    var castRes = result as ProjectScheduler;
    output!.writeLine(castRes.finalProject.length.toString());
    for (var project in castRes.finalProject) {
      output!.writeLine(project.name);
      var contributors = "";
      for (var key in project.contributorRoles.keys) {
        var con = project.contributorRoles[key]!;
        contributors += "${con.name} ";
      }
      output!.writeLine(contributors.trimRight());
    }
  }
}
