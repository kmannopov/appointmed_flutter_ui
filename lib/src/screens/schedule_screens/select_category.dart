import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/screens/schedule_screens/select_clinic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

List<Map> categories = [
  {'icon': Icons.favorite, 'text': 'Cardiology', 'color': Colors.red},
  {'icon': Icons.bloodtype, 'text': 'Endocrinology', 'color': Colors.red},
  {
    'icon': FontAwesomeIcons.brain,
    'text': 'Neurology',
    'color': Colors.pink.shade100
  },
  {'icon': Icons.female, 'text': 'OBGYN', 'color': Colors.purple},
  {
    'icon': Icons.directions_run,
    'text': 'Physical Therapy',
    'color': Colors.green
  },
  {
    'icon': FontAwesomeIcons.tooth,
    'text': 'Stomatology',
    'color': Colors.white
  },
];

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Text(
            "Please select a category: ",
            style: TextStyle(
              color: Palette.mainColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      for (var category in categories)
                        CategoryIcon(
                          icon: category['icon'],
                          text: category['text'],
                          color: category['color'],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const CategoryIcon({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Palette.primary.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      alignment: Alignment.center,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: SelectClinicScreen(category: text),
                  type: PageTransitionType.rightToLeftWithFade));
        },
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        splashColor: Colors.deepPurple.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 60,
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Palette.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
