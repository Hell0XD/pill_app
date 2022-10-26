import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pill_app/shared/button.dart';
import 'package:pill_app/state.dart';
import 'package:provider/provider.dart';
import '../consts.dart' as consts;
import 'dart:math' as math;

class AddPillPage2Arguments {
  final String medName;
  final int dosage;
  final consts.When when;
  final consts.Med med;

  AddPillPage2Arguments(this.medName, this.dosage, this.when, this.med);
}

class AddPillPage2 extends StatelessWidget {
  const AddPillPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AddPillPage2Arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset("icons/24 Back.svg")),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset("icons/24 Close.svg")),
              ],
            ),
            const SizedBox(
              height: consts.s12,
            ),
            const Text(
              "2 of 2",
              style: TextStyle(
                color: consts.gray,
                fontSize: consts.s,
              ),
            ),
            const SizedBox(
              height: consts.s12,
            ),
            const Text(
              "Schedule",
              style: TextStyle(
                  color: consts.dark,
                  fontSize: consts.xl,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: consts.s40,
            ),
            Preview(
              medName: args.medName,
              count: args.dosage,
              med: args.med,
              when: args.when,
            ),
            const SizedBox(
              height: consts.s12,
            ),
            AddPill2Form(
              medInfo: args,
            ),
          ],
        ),
      ),
    );
  }
}

class AddPill2Form extends StatefulWidget {
  final AddPillPage2Arguments medInfo;
  const AddPill2Form({Key? key, required this.medInfo}) : super(key: key);

  @override
  State<AddPill2Form> createState() => AddPill2_FormState();
}

class AddPill2_FormState extends State<AddPill2Form> {
  String? time;
  List<String?> doses = [
    null,
  ];

  bool reminders = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height / 4,
          child: ListView(
              children: doses
                  .asMap()
                  .entries
                  .map((e) => Dose(
                        key: ValueKey(e.key),
                        index: e.key,
                        time: e.value,
                        setTime: (newTime) =>
                            setState(() => doses[e.key] = newTime),
                      ))
                  .toList()),
        ),
        IconButton(
          padding: const EdgeInsets.all(0),
          iconSize: 48,
          onPressed: () => setState(() => doses.add(null)),
          icon: Container(
            decoration: BoxDecoration(
                color: consts.gray4, borderRadius: BorderRadius.circular(25)),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset("icons/24 Plus.svg")),
          ),
        ),
        const SizedBox(
          height: consts.s12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reminders",
              style: TextStyle(
                  color: consts.dark,
                  fontSize: consts.m,
                  fontWeight: FontWeight.bold),
            ),
            FlutterSwitch(
                width: 54,
                height: 32,
                toggleSize: 22,
                activeColor: consts.gray4,
                inactiveColor: consts.gray4,
                activeToggleColor: consts.blue,
                value: reminders,
                onToggle: (value) => setState(() => reminders = value))
          ],
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Button(
                isValid: !doses.contains(null),
                successText: "Done",
                action: () {
                  if (!doses.contains(null)) {
                    Provider.of<AppModel>(context, listen: false).addMedication(
                        Medication(
                            widget.medInfo.medName,
                            widget.medInfo.dosage,
                            widget.medInfo.when,
                            widget.medInfo.med,
                            doses[0]!));
                    Navigator.pushNamed(context, "/");
                  }
                },
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class Dose extends StatelessWidget {
  const Dose({
    Key? key,
    required this.index,
    required this.time,
    required this.setTime,
  }) : super(key: key);

  final String? time;
  final Function(String?) setTime;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dose ${index + 1}",
          style: const TextStyle(
              color: consts.dark,
              fontSize: consts.m,
              fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () async {
              var result = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              setTime(result == null
                  ? null
                  : "${extendTo2Digits(result.hour)}:${extendTo2Digits(result.minute)}");
            },
            child: Text(time ?? "00:00",
                style: TextStyle(
                    color: time == null ? consts.gray2 : consts.dark,
                    fontSize: consts.m,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class Preview extends StatelessWidget {
  final String medName;
  final consts.Med med;
  final consts.When when;
  final int count;

  const Preview(
      {Key? key,
      required this.medName,
      required this.count,
      required this.med,
      required this.when})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            color: consts.gray4,
            width: 5,
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Transform.rotate(
              angle: math.pi / 2.5,
              child: Image(
                image: AssetImage(consts.medOptions[med]!),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medName,
                  style: const TextStyle(
                      fontSize: consts.m,
                      fontWeight: FontWeight.bold,
                      color: consts.dark),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$count tablets ${consts.whenOptions[when]}",
                      style: const TextStyle(
                          fontSize: consts.s, color: consts.gray),
                    ),
                    const Text(
                      "7 days left",
                      style: TextStyle(fontSize: consts.s, color: consts.gray),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String extendTo2Digits(int num) {
  var s = num.toString();
  return s.length == 1 ? "0" + s : s;
}
