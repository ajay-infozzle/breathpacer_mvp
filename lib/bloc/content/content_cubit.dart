import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:breathpacer_mvp/config/model/exercise_content_model.dart';
// import 'package:breathpacer_mvp/utils/constant/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(ContentInitial());

  ExerciseContentModel exerciseContentModel = ExerciseContentModel();
  List<ExerciseOption> interactionOptions = [];
  List<PyramindStepGuide> breathingStepGuide = [];
  String noteFromJerry = "";
  String doYouReallyWantToActivateYourSuperhumanPotential = "";
  List<Faq> faq = [];
  String imagePath = "";
  Images images = Images.fromJson({});

  Future<bool> loadContents() async {
    emit(ContentLoading());

    /*
    await Future.delayed(
      Duration(seconds: 4),
      () {
        try {
          saveContent(testData);
          emit(ContentLoaded());
          
          if(interactionOptions.isEmpty || breathingStepGuide.isEmpty || faq.isEmpty ){
            return false;
          }
        } on Exception catch (e) {
          emit(ContentLoadingError(e.toString()));
          showToast(e.toString());
          return false;
        }
      },
    );*/

    // /*
    try {
      final uri = Uri.parse(
        "https://www.starmagichealing.org/wp-json/custom/v1/breathpacer_content",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        saveContent(data);
        emit(ContentLoaded());
        if(interactionOptions.isEmpty || breathingStepGuide.isEmpty || faq.isEmpty ){
          return false;
        }
      } else {
        emit(
          ContentLoadingError(
            "Failed with status code: ${response.statusCode}",
          ),
        );
        return false ;
      }
    } catch (e) {
      emit(ContentLoadingError(e.toString()));
      return false;
    } 
    // */

    return true;
  }

  void saveContent(dynamic data){
    exerciseContentModel = ExerciseContentModel.fromJson(data);
    interactionOptions = exerciseContentModel.exerciseOption ?? interactionOptions;
    breathingStepGuide = exerciseContentModel.pyramindStepGuide ?? breathingStepGuide;
    noteFromJerry = exerciseContentModel.noteFromJerry ?? noteFromJerry;
    doYouReallyWantToActivateYourSuperhumanPotential = exerciseContentModel.toActivateYourSuperhumanPotential ?? doYouReallyWantToActivateYourSuperhumanPotential;
    faq = exerciseContentModel.faq ?? faq;
    images = exerciseContentModel.images ?? images;
    imagePath = exerciseContentModel.imagePath ?? imagePath ;
  } 

}



// test json
const testData = {
    "exerciseOption": [
        {
            "title": "Pyramid Breathing",
            "image": "assets/images/pyramid_icon.png",
            "description": "Discover relaxation and mental clarity with Pyramid Breathing. Choose from two easy options—12-9-6-3 or 12-6 breathing patterns—to calm your mind and boost focus, anytime, anywhere."
        },
        {
            "title": "Fire Breathing",
            "image": "assets/images/fire_icon.png",
            "description": "Let go of toxins and chemicals from the cells in your body. Enhance mental clarity. Start your day with this powerful activator. Do it anytime you need a boost of energy. Fire Breathing is an intense rapid breathing exercise done through the nose. Inhale deeply through your nose and exhale forcefully through your nose in a continuous steady pace. At the end of the set hold your breath and recover."
        },
        {
            "title": "DNA Breathing",
            "image": "assets/images/dna_icon.png",
            "description": "Powerful breathing technique that will energize and renew you at a cellular level  by targeting stuck emotions and past trauma. Breathe deeply and continuously through your mouth and hold your breath at the end of each set. "
        },
        {
            "title": "Pineal Gland Activation",
            "image": "assets/images/pineal_icon.png",
            "description": "Activate your pineal gland with this powerful breath. Start by squeezing your buttocks, genitals and perineum and pulling your abdominals back to your spine. Put the tip of your tongue on the roof of your mouth, the rough spot right behind your 2 top center teeth. Keep your focus in the center of your brain and back slightly, in your pineal gland. As you breathe in through your nose, pull the platinum light from mother earth’s heart from your perineum up your spine and into your crown. Hold as long as you can.  Let go of the squeeze and exhale gently through the mouth."
        }
    ],
    "pyramindStepGuide": [
        {
            "title": "4-Step Pyramid Breathing (12-9-6-3)",
            "description": "Relax step by step. Inhale deeply and hold for 12, 9, 6, and 3 counts, exhaling after each. A great way to unwind progressively.",
            "instruction": "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
        },
        {
            "title": "2-Step Pyramid Breathing (12-6)",
            "description": "Simplify your breathing practice. Hold for 12 counts, then 6 counts, with a full exhale in between. Quick and effective for instant calm.",
            "instruction": "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
        }
    ],
    "noteFromJerry": "I just want to remind you before you get into this breathing that You’re a Spiritual Gangsta, you’re a Jedi from the Stars, and you came to planet Earth to play at a level beyond phenomenal. Every time you do one of these breathwork routines, you are elevating, you’re expanding, and activating to your super human potential.\n\nEvery time you don’t, you’re sliding backwards. It's inevitable, it happens to me, happens to everyone. Plant this seed in your mind, and just know that this isn’t an option.\n\nIf you are a Jedi, which I know you are, then this Breathwork is a must.\n\nSome days you may have less time - do 3 minutes, if you have more, do 30 minutes. Before you get into this, it's really important that you remember Star Magic is a lifestyle. And that lifestyle comes at a price of discipline, commitment, and focus.",
    "toActivateYourSuperhumanPotential": "If No, Then this isn’t the place for you.\n\nIf Yes, Then its time to dig deep and take some massive action!\n\nRemember when you finish this breathwork routine today, make sure you’ve got no regrets.\n\nOne Love, One Heart, One Human Family\nJERRY SARGEANT",
    "faq": [
        {
            "ques": "Why Are We Doing Breathwork ?",
            "ans": "Breathwork floods the body with light and oxygen, helping to break up, surface and shed old traumas and stored toxicities. Through conscious breathing, we prime ourselves for healing by softening the nervous system, awakening cellular memory, and preparing our cells to receive deeper transformation in meditation. Breathwork and meditation work hand in hand: the breath clears and activates, while meditation integrates and recalibrates. This combination resets the nervous system, boosts the lymphatic system, and supercharges the pineal gland."
        },
        {
            "ques": "When Should You Do These Different Kinds of Breath ?",
            "ans": "DNA Breathing: Before Bed\nFire Breathing: Before Gym or business meeting or after you get home after a day at work to go and see your family\nPineal Gland: Do it whenever! Whenever you feel you want to activate your pineal gland.\nPyramid Breathing: For relaxation, bringing balance and grounding."
        },
        {
            "ques": "Why Does Jerry Always Say No Regrets ?",
            "ans": "To not leave anything behind. To give it your all, really commit and be disciplined with your lifestyle and have no regrets about the effort you gave. To Truly Give It EVERYTHING, so that you can transform and expand to your highest potential."
        },
        {
            "ques": "Why is Discipline & Commitment Important ?",
            "ans": "Discipline is the highest form of self-love. You gotta be committed to the process, because life is full of distractions. And when you start committing to the lifestyle of infinity - your friends, your family, your kids they’re all going to try to get you to do other stuff to pull you out of your process, but you gotta commit to being a Spiritual Gangsta and stick to it."
        }
    ],
    "imagePath": "assets/images/",
    "images": {
        "jerryImage": "healing_jerry.png",
        "pyramidIcon": "pyramid_icon.png",
        "dnaIcon": "dna_icon.png",
        "pinealIcon": "pineal_icon.png",
        "holdImage": "hold.png",
        "timeImage": "time.png",
        "voiceImage": "voice.png",
        "musicImage": "music.png",
        "chimeImage": "chime.png",
        "fireIcon": "fire_icon.png",
        "breathInIcon": "breath_in.png",
        "breathOutIcon": "breath_out.png",
        "breathHoldIcon": "breath_hold.png",
        "recoveryBreathIcon": "recovery_breath.png",
        "recoveryIcon": "recovery.png",
        "completionIcon": "completion_icon.png"
    }
};