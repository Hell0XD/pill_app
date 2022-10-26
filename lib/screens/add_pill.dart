import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_app/screens/add_pill2.dart';
import 'package:pill_app/shared/button.dart';
import '../consts.dart' as consts;

class AddPillPage extends StatelessWidget {
  const AddPillPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              "1 of 2",
              style: TextStyle(
                color: consts.gray,
                fontSize: consts.s,
              ),
            ),
            const SizedBox(
              height: consts.s12,
            ),
            const Text(
              "Add medication",
              style: TextStyle(
                  color: consts.dark,
                  fontSize: consts.xl,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: consts.s40,
            ),
            const AddPillForm(),
          ],
        ),
      ),
    );
  }
}

class AddPillForm extends StatefulWidget {
  const AddPillForm({Key? key}) : super(key: key);

  @override
  State<AddPillForm> createState() => _AddPillFormState();
}

class _AddPillFormState extends State<AddPillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final dosage = TextEditingController();

  consts.When? when;
  consts.Med? med;

  bool isValid = false;

  void validate() {
    bool last = isValid;
    isValid = when != null &&
        med != null &&
        name.text.isNotEmpty &&
        dosage.text.isNotEmpty;
    if (last != isValid) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    validate();

    return Form(
      key: _formKey,
      child: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: consts.medOptions.entries
                  .map((entry) => MedicationType(
                      select: () => setState(() => med = entry.key),
                      iconPath: entry.value,
                      isSelected: entry.key == med))
                  .toList(),
            ),
            const SizedBox(
              height: consts.s40,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              onChanged: (_) => validate(),
              controller: name,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  color: consts.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: consts.m),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                  hintStyle: TextStyle(
                      color: consts.gray2,
                      fontSize: consts.m,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: consts.s24,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              onChanged: (_) => validate(),
              controller: dosage,
              style: const TextStyle(
                  color: consts.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: consts.m),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Single dose, eg. 1 tablet',
                  hintStyle: TextStyle(
                      color: consts.gray2,
                      fontSize: consts.m,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: consts.s24,
            ),
            SizedBox(
              height: 40,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: consts.whenOptions.entries
                    .map((entry) => PillButton(
                          isActive: when == entry.key,
                          text: entry.value,
                          select: () => setState(() => when = entry.key),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: Button(
                    isValid: isValid,
                    successText: "Next",
                    action: () => isValid
                        ? Navigator.pushNamed(context, "/add_pill2",
                            arguments: AddPillPage2Arguments(
                                name.text, int.parse(dosage.text), when!, med!))
                        : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MedicationType extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final Function() select;

  const MedicationType({
    Key? key,
    required this.iconPath,
    required this.isSelected,
    required this.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        splashRadius: 1,
        iconSize: 60,
        onPressed: select,
        icon: Badge(
          showBadge: isSelected,
          badgeContent: SvgPicture.asset(
            "icons/18 Check.svg",
          ),
          badgeColor: Colors.transparent,
          elevation: 0,
          position: BadgePosition.topEnd(top: -6, end: -8),
          child: Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: consts.gray4, borderRadius: BorderRadius.circular(35)),
            child: Image(
              image: AssetImage(iconPath),
            ),
          ),
        ));
  }
}

class PillButton extends StatelessWidget {
  final bool isActive;
  final String text;
  final Function() select;

  const PillButton(
      {Key? key,
      required this.isActive,
      required this.text,
      required this.select})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: select,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: isActive ? consts.gray4 : Colors.white,
              borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: consts.m,
                  color: isActive ? consts.dark : consts.gray2,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
