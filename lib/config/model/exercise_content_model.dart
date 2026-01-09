class ExerciseContentModel {
  List<ExerciseOption>? exerciseOption;
  List<PyramindStepGuide>? pyramindStepGuide;
  String? noteFromJerry;
  String? toActivateYourSuperhumanPotential;
  List<Faq>? faq;
  String? imagePath;
  Images? images;

  ExerciseContentModel(
      {this.exerciseOption,
      this.pyramindStepGuide,
      this.noteFromJerry,
      this.toActivateYourSuperhumanPotential,
      this.faq,
      this.imagePath,
      this.images});

  ExerciseContentModel.fromJson(Map<String, dynamic> json) {
    if (json['exerciseOption'] != null) {
      exerciseOption = <ExerciseOption>[];
      json['exerciseOption'].forEach((v) {
        exerciseOption!.add(ExerciseOption.fromJson(v));
      });
    }
    if (json['pyramindStepGuide'] != null) {
      pyramindStepGuide = <PyramindStepGuide>[];
      json['pyramindStepGuide'].forEach((v) {
        pyramindStepGuide!.add(PyramindStepGuide.fromJson(v));
      });
    }
    noteFromJerry = json['noteFromJerry'];
    toActivateYourSuperhumanPotential =
        json['toActivateYourSuperhumanPotential'];
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(Faq.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (exerciseOption != null) {
      data['exerciseOption'] =
          exerciseOption!.map((v) => v.toJson()).toList();
    }
    if (pyramindStepGuide != null) {
      data['pyramindStepGuide'] =
          pyramindStepGuide!.map((v) => v.toJson()).toList();
    }
    data['noteFromJerry'] = noteFromJerry;
    data['toActivateYourSuperhumanPotential'] =
        toActivateYourSuperhumanPotential;
    if (faq != null) {
      data['faq'] = faq!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = imagePath;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    return data;
  }
}

class ExerciseOption {
  String? title;
  String? image;
  String? description;

  ExerciseOption({this.title, this.image, this.description});

  ExerciseOption.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    return data;
  }
}

class PyramindStepGuide {
  String? title;
  String? description;
  String? instruction;

  PyramindStepGuide({this.title, this.description, this.instruction});

  PyramindStepGuide.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['instruction'] = instruction;
    return data;
  }
}

class Faq {
  String? ques;
  String? ans;

  Faq({this.ques, this.ans});

  Faq.fromJson(Map<String, dynamic> json) {
    ques = json['ques'];
    ans = json['ans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ques'] = ques;
    data['ans'] = ans;
    return data;
  }
}

class Images {
  String? jerryImage;
  String? pyramidIcon;
  String? dnaIcon;
  String? pinealIcon;
  String? holdImage;
  String? timeImage;
  String? voiceImage;
  String? musicImage;
  String? chimeImage;
  String? fireIcon;
  String? breathInIcon;
  String? breathOutIcon;
  String? breathHoldIcon;
  String? recoveryBreathIcon;
  String? recoveryIcon;
  String? completionIcon;

  Images(
      {this.jerryImage,
      this.pyramidIcon,
      this.dnaIcon,
      this.pinealIcon,
      this.holdImage,
      this.timeImage,
      this.voiceImage,
      this.musicImage,
      this.chimeImage,
      this.fireIcon,
      this.breathInIcon,
      this.breathOutIcon,
      this.breathHoldIcon,
      this.recoveryBreathIcon,
      this.recoveryIcon,
      this.completionIcon});

  Images.fromJson(Map<String, dynamic> json) {
    jerryImage = json['jerryImage'];
    pyramidIcon = json['pyramidIcon'];
    dnaIcon = json['dnaIcon'];
    pinealIcon = json['pinealIcon'];
    holdImage = json['holdImage'];
    timeImage = json['timeImage'];
    voiceImage = json['voiceImage'];
    musicImage = json['musicImage'];
    chimeImage = json['chimeImage'];
    fireIcon = json['fireIcon'];
    breathInIcon = json['breathInIcon'];
    breathOutIcon = json['breathOutIcon'];
    breathHoldIcon = json['breathHoldIcon'];
    recoveryBreathIcon = json['recoveryBreathIcon'];
    recoveryIcon = json['recoveryIcon'];
    completionIcon = json['completionIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jerryImage'] = jerryImage;
    data['pyramidIcon'] = pyramidIcon;
    data['dnaIcon'] = dnaIcon;
    data['pinealIcon'] = pinealIcon;
    data['holdImage'] = holdImage;
    data['timeImage'] = timeImage;
    data['voiceImage'] = voiceImage;
    data['musicImage'] = musicImage;
    data['chimeImage'] = chimeImage;
    data['fireIcon'] = fireIcon;
    data['breathInIcon'] = breathInIcon;
    data['breathOutIcon'] = breathOutIcon;
    data['breathHoldIcon'] = breathHoldIcon;
    data['recoveryBreathIcon'] = recoveryBreathIcon;
    data['recoveryIcon'] = recoveryIcon;
    data['completionIcon'] = completionIcon;
    return data;
  }
}