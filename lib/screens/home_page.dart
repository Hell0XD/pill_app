import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_app/state.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../consts.dart' as consts;
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const List<ChartData> chartData = [
    ChartData('Full', 10, consts.green),
    ChartData('Empty', 0, Color.fromRGBO(0, 0, 0, 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/add_pill"),
        child: SvgPicture.asset(
          "icons/24 Big-plus.svg",
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 24, right: 24),
          child: Column(
            children: [
              const Day(),
              const SizedBox(height: consts.s24),
              Container(
                height: 126,
                padding: const EdgeInsets.all(21),
                decoration: BoxDecoration(
                    border: Border.all(color: consts.gray3),
                    borderRadius: const BorderRadius.all(Radius.circular(24))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          const Text(
                            "Your plan is almost done!",
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: consts.dark,
                                fontSize: consts.l,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "icons/12 Up.svg",
                                  color: consts.green,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "13% than week ago",
                                    style: TextStyle(
                                        color: consts.gray, fontSize: consts.s),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Graph(chartData: chartData)
                  ],
                ),
              ),
              const MedsList()
            ],
          ),
        ),
      ),
    );
  }
}

class MedsList extends StatelessWidget {
  const MedsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
        builder: (context, model, child) =>
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView(
                    children: model.meds.map((e) => OneMed(med: e)).toList(),
                  ),
                )));
  }
}

class OneMed extends StatelessWidget {
  final Medication med;

  const OneMed({Key? key, required this.med}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            CustomSlidableAction(onPressed: (ctx) {
              Provider.of<AppModel>(context, listen: false).setMedDone(med.id);
            }, child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: consts.gray3),
                  borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.check, color: med.done ? Colors.green : null,),
            ))
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            CustomSlidableAction(onPressed: (ctx) {
              Provider.of<AppModel>(context, listen: false).removeMedication(med.id);
            }, child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: consts.gray3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.delete_outline_outlined),
            ))
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(consts.s24),
          decoration: BoxDecoration(
              border: Border.all(color: consts.gray3),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: [
              Image(image: AssetImage(consts.medOptions[med.med]!)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: const TextStyle(
                            color: consts.dark,
                            fontSize: consts.m,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${med.dosage} tablet ${consts.whenOptions[med.when]?.toLowerCase()}",
                              style: const TextStyle(
                                  color: consts.gray, fontSize: consts.s)),
                          const Text(
                            "7 days",
                            textAlign: TextAlign.end,
                            style: TextStyle(color: consts.gray, fontSize: consts.s),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Graph extends StatelessWidget {
  const Graph({
    Key? key,
    required this.chartData,
  }) : super(key: key);

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
          color: consts.pale, borderRadius: BorderRadius.circular(60)),
      child: Consumer<AppModel>(
        builder: (context, model, child) {
          return SfCircularChart(annotations: [
            CircularChartAnnotation(
                widget: SizedBox(
                    width: 65,
                    height: 65,
                    child: PhysicalModel(
                        child: Container(),
                        shape: BoxShape.circle,
                        color: Colors.white))),
            CircularChartAnnotation(
                widget: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((model.doneMedCount / (model.doneMedCount + model.notDoneMedCount) * 100).floor().toString(),
                          style: const TextStyle(
                              color: consts.green,
                              fontSize: consts.l,
                              fontWeight: FontWeight.bold)),
                      const Text('%',
                          style: TextStyle(
                            color: consts.green,
                            fontSize: consts.xs,
                          ))
                    ],
                  ),
                ))
          ], series: <CircularSeries>[
            // Renders doughnut chart
            DoughnutSeries<ChartData, String>(
                dataSource: [
                  ChartData('Full', model.doneMedCount.toDouble(), consts.green),
                  ChartData('Empty', model.notDoneMedCount.toDouble(), const Color.fromRGBO(0, 0, 0, 0)),
                ],
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                innerRadius: "77%",
                radius: "135%",
                cornerStyle: model.notDoneMedCount == 0 ? CornerStyle.bothFlat : CornerStyle.bothCurve)
          ]);
        }
      ),
    );
  }
}

class Day extends StatelessWidget {
  const Day({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Thursday",
          style: TextStyle(
              fontSize: consts.xl,
              color: consts.dark,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SvgPicture.asset("icons/18 Arrow-down.svg"),
        )
      ],
    );
  }
}

class ChartData {
  const ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
