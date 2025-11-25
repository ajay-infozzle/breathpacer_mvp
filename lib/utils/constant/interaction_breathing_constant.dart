const interactionOptions = [
  {
    "title": "Pyramid Breathing",
    "image": "assets/images/pyramid_icon.png",
    "description": "Discover relaxation and mental clarity with Pyramid Breathing. Choose from two easy options—12-9-6-3 or 12-6 breathing patterns—to calm your mind and boost focus, anytime, anywhere.",
  },
  {
    "title": "Fire Breathing",
    "image": "assets/images/fire_icon.png",
    "description": "Release toxins and chemicals from the cells in your body. Enhance mental clarity. Start your day with this powerful activator.  Do it anytime you need a boost of energy. Fire Breathing is an intense rapid breathing exercises done through the nose.  Inhale deeply through your nose and exhale forcefully through your nose in a continuous steady pace.  At the end of the set hold your breath and recover.",
  },
  {
    "title": "DNA Breathing",
    "image": "assets/images/dna_icon.png",
    "description": "Powerful breathing technique that will energize and renew you at a cellular level, releasing stuck emotions and past trauma.  Breathe deeply and continuously through your mouth and hold your breath at the end of each set. ",
  },
  // {
  //   "title": "Pineal Gland Activation",
  //   "image": "assets/images/pineal_icon.png",
  //   "description": "Activate your pineal gland with this powerful breath.  Start by squeezing your buttocks, genitals and perineum and pulling your abdominals back to your spine.  Put the tip of your tongue on the roof of your mouth, the rough spot right behind your 2 top center teeth.  Keep your focus in the center of your brain and back slightly, in your pineal gland.   As you breath in through your nose, pull the platinum light from mother earth’s heart from your perineum up your spine and into your crown. Hold as long as you can.  Release the squeeze and exhale gently through the mouth.",
  // },
];


//~ for pyramid
const breathingStepGuide = [
  {
    "title": "4-Step Pyramid Breathing (12-9-6-3)",
    "description": "Relax step by step. Inhale deeply and hold for 12, 9, 6, and 3 counts, exhaling after each. A great way to unwind progressively.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  },
  {
    "title": "2-Step Pyramid Breathing (12-6)",
    "description": "Simplify your breathing practice. Hold for 12 counts, then 6 counts, with a full exhale in between. Quick and effective for instant calm.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  }
];


String noteFromJerry = "I just want to remind you before you get into this breathing that You’re a Spiritual Gangsta, you’re a Jedi from the Stars, and you came to planet Earth to play at a level beyond phenomenal. Every time you do one of these breathwork routines, you are elevating, you’re expanding, and activating to your super human potential.\n\nEvery time you don’t, you’re sliding backwards. It's inevitable, it happens to me, happens to everyone. Plant this seed in your mind, and just know that this isn’t an option.\n\nIf you are a Jedi, which I know you are, then this Breathwork is a must.\n\nSome days you may have less time - do 3 minutes, if you have more, do 30 minutes. Before you get into this, it's really important that you remember Star Magic is a lifestyle. And that lifestyle comes at a price of discipline, commitment, and focus.";

String doYouReallyWantToActivateYourSuperhumanPotential = "If No, Then this isn’t the place for you.\n\nIf Yes, Then its time to dig deep and take some massive action!\n\nRemember when you finish this breathwork routine today, make sure you’ve got no regrets.\n\nOne Love, One Heart, One Human Family\nJERRY SARGEANT";

const faq = [
  {
    "ques" : "Why Are We Doing Breathwork ?",
    "ans" : "Breathwork floods the body with light and oxygen, helping to break up, surface and shed old traumas and stored toxicities. Through conscious breathing, we prime ourselves for healing by softening the nervous system, awakening cellular memory, and preparing our cells to receive deeper transformation in meditation. Breathwork and meditation work hand in hand: the breath clears and activates, while meditation integrates and recalibrates. This combination resets the nervous system, boosts the lymphatic system, and supercharges the pineal gland."
  },
  {
    "ques" : "When Should You Do These Different Kinds of Breath ?",
    "ans" : "DNA Breathing: Before Bed\nFire Breathing: Before Gym or business meeting or after you get home after a day at work to go and see your family\nPineal Gland: Do it whenever! Whenever you feel you want to activate your pineal gland.\nPyramid Breathing: For relaxation, bringing balance and grounding."
  },
  {
    "ques" : "Why Does Jerry Always Say No Regrets ?",
    "ans" : "To not leave anything behind. To give it your all, really commit and be disciplined with your lifestyle and have no regrets about the effort you gave. To Truly Give It EVERYTHING, so that you can transform and expand to your highest potential."
  },
  {
    "ques" : "Why is Discipline & Commitment Important ?",
    "ans" : "Discipline is the highest form of self-love. You gotta be committed to the process, because life is full of distractions. And when you start committing to the lifestyle of infinity - your friends, your family, your kids they’re all going to try to get you to do other stuff to pull you out of your process, but you gotta commit to being a Spiritual Gangsta and stick to it."
  },
];


List<String> musicList = ['None','Music 1', 'Music 2'] ;


/// enums
enum AudioStatus { stopped, playing, paused, error }

enum BreathSpeed { 
  standard("Standard"), 
  fast("Fast"), 
  slow("Slow");

  final String name;
  const BreathSpeed(this.name);
}

enum BreathSpeedDuration { 
  standard("2450"), 
  fast("1400"), 
  slow("3450");

  final String duration;
  const BreathSpeedDuration(this.duration);
}

enum BreathHoldChoice { 
  breatheIn("Breath in"),
  breatheOut("Breath out"),
  both("Both");

  final String name;
  const BreathHoldChoice(this.name);
}

const String audioAssetFile = "assets/audio/";
enum MusicTrack {
  track1("${audioAssetFile}music_1.mp3"),
  track2("${audioAssetFile}music_2.mp3");

  final String path;
  const MusicTrack(this.path);
}

enum GuideTrack{
  chime("${audioAssetFile}chime.mp3"),
  skipIntro("${audioAssetFile}skip_intro.mp3"), 
  fourStepStart("${audioAssetFile}four_step_start.mp3"),
  twoStepStart("${audioAssetFile}two_step_start.mp3"),
  singleBreathIn("${audioAssetFile}single_breath_in_standard.mp3"),
  singleBreathOut("${audioAssetFile}single_breath_out_standard.mp3"),
  three("${audioAssetFile}3.mp3"),
  two("${audioAssetFile}2.mp3"),
  one("${audioAssetFile}1.mp3"),
  getReadyTohold("${audioAssetFile}get_ready_to_hold.mp3"),
  breathOutNext("${audioAssetFile}breath_out_next.mp3"), 
  breathInNext("${audioAssetFile}breath_in_next.mp3"), 
  getReadyToBreathIn("${audioAssetFile}ready_to_breath_in.mp3"),
  getReadyToBreathOut("${audioAssetFile}ready_to_breath_out.mp3"), 
  nowHold("${audioAssetFile}now_hold.mp3"),
  relax("${audioAssetFile}relax.mp3"),

  firebreathingPinealStart("${audioAssetFile}firebreathing_pineal_start.mp3"),
  firebreathingStart("${audioAssetFile}firebreathing_start.mp3"),
  firebreathing("${audioAssetFile}firebreathing.mp3"),
  firebreathingPineal("${audioAssetFile}firebreathing_pineal.mp3"),
  getReadyToRecover("${audioAssetFile}ready_to_recover.mp3"),
  getReadyForNextSet("${audioAssetFile}ready_for_next_set.mp3"),

  dnaStart("${audioAssetFile}dna_start.mp3"),
  
  nowRecover("${audioAssetFile}now_recover.mp3"),
  timeToNextSet("${audioAssetFile}time_to_next_set.mp3"), //Todo: change
  minToGo6("${audioAssetFile}6_min_to_go.mp3"),
  minToGo5("${audioAssetFile}5_min_to_go.mp3"),
  minToGo4("${audioAssetFile}4_min_to_go.mp3"),
  minToGo3("${audioAssetFile}3_min_to_go.mp3"),
  minToGo2("${audioAssetFile}2_min_to_go.mp3"),
  minToGo1("${audioAssetFile}1_min_to_go.mp3"),
  secToGo30("${audioAssetFile}30_sec_to_go.mp3"),
  secToGo15("${audioAssetFile}15_sec_to_go.mp3"),
  secToGo5("${audioAssetFile}5_sec_to_go.mp3"),
  noRegret("${audioAssetFile}no_regret.mp3"),
  motivation_1("${audioAssetFile}motivation_1.mp3"),
  motivation_2("${audioAssetFile}motivation_2.mp3"), //Todo: change
  motivation_2_1("${audioAssetFile}motivation_2_1.mp3"), 
  motivation_3("${audioAssetFile}motivation_3.mp3");

  final String path;
  const GuideTrack(this.path);
}

const String imageAssetFile = "assets/images/" ;
enum ImagePath{
  jerryImage("${imageAssetFile}healing_jerry.png"),
  pyramidIcon("${imageAssetFile}pyramid_icon.png"),
  dnaIcon("${imageAssetFile}dna_icon.png"),
  pinealIcon("${imageAssetFile}pineal_icon.png"),
  holdImage("${imageAssetFile}hold.png"),
  timeImage("${imageAssetFile}time.png"),
  voiceImage("${imageAssetFile}voice.png"),
  musicImage("${imageAssetFile}music.png"),
  chimeImage("${imageAssetFile}chime.png"),
  fireIcon("${imageAssetFile}fire_icon.png"),
  breathHoldIcon("${imageAssetFile}breath_hold.png"),
  recoveryBreathIcon("${imageAssetFile}recovery_breath.png"),
  recoveryIcon("${imageAssetFile}recovery.png"),
  completionIcon("${imageAssetFile}completion_icon.png");

  final String path;
  const ImagePath(this.path);
}
///


String getTotalTimeString(List<int> timeList) {
  if (timeList.isEmpty) return '0 secs';

  int totalSeconds = timeList.reduce((a, b) => a + b);

  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  String timeString = '';

  if (hours > 0) {
    timeString += '$hours hr';
    if (hours > 1) timeString += 's';
  }

  if (minutes > 0) {
    if (timeString.isNotEmpty) timeString += ' ';
    timeString += '$minutes min';
    if (minutes > 1) timeString += 's';
  }

  if (seconds > 0 || timeString.isEmpty) {
    if (timeString.isNotEmpty) timeString += ' ';
    timeString += '$seconds sec';
    if (seconds > 1) timeString += 's';
  }

  return timeString;
}

String getFormattedTime(int seconds) {
  if (seconds < 60) {
    return '$seconds sec';
  } else {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return remainingSeconds > 0
        ? '$minutes m $remainingSeconds s'
        : '$minutes min';
  }
}