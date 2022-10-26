import 'package:flutter/material.dart';

// Main colors
const Color green = Color.fromRGBO(103, 183, 121, 1);
const Color pale = Color.fromRGBO(233, 243, 225, 1);
const Color blue = Color.fromRGBO(24, 146, 250, 1);
const Color orange = Color.fromRGBO(249, 87, 33, 1);

// Secondary colors
const Color dark = Color.fromRGBO(25, 29, 48, 1);
const Color gray = Color.fromRGBO(140, 142, 151, 1);
const Color gray2 = Color.fromRGBO(196, 202, 207, 1);
const Color gray3 = Color.fromRGBO(236, 237, 239, 1);
const Color gray4 = Color.fromRGBO(242, 246, 247, 1);
const Color gray5 = Color.fromRGBO(244, 244, 245, 1);

// Text sizes
const double xl = 34;
const double l = 24;
const double m = 20;
const double s = 16;
const double xs = 14;

// Spacing
const double s44 = 44;
const double s40 = 40;
const double s36 = 36;
const double s28 = 28;
const double s24 = 24;
const double s16 = 16;
const double s12 = 12;

enum Med { pill, caps, amp, ing }

const medOptions = {
  Med.pill: "icons/pill.png",
  Med.caps: "icons/caps.png",
  Med.amp: "icons/amp.png",
  Med.ing: "icons/ing.png",
};

enum When {
  nevermind,
  beforeMeals,
  afterMeals,
  withFoods,
}

const whenOptions = {
  When.nevermind: "Nevermind",
  When.beforeMeals: "Before meals",
  When.afterMeals: "After meals",
  When.withFoods: "With foods"
};
