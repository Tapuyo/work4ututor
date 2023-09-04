import 'package:flutter/material.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/shared_components/responsive_builder.dart';
import 'package:wokr4ututor/ui/web/admin/admin_models/daily_info_model.dart';
import 'package:wokr4ututor/ui/web/admin/reports/mini_information_widget.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         backgroundColor: Colors.green,
        //         padding: EdgeInsets.symmetric(
        //           horizontal: kSpacing * 1.5,
        //           vertical:
        //               kSpacing / (ResponsiveBuilder.isMobile(context) ? 2 : 1),
        //         ),
        //       ),
        //       onPressed: () {
        //         Navigator.of(context).push(MaterialPageRoute<void>(
        //             builder: (BuildContext context) {
        //               return Container();
        //             },
        //             fullscreenDialog: true));
        //       },
        //       icon: const Icon(Icons.add),
        //       label: const Text(
        //         "Add New",
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: kSpacing / 2),
        ResponsiveBuilder(
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return InformationCard(
              childAspectRatio: _size.width < 1400 ? 1.2 : 1.4,
            );
          },
          mobileBuilder: (BuildContext context, BoxConstraints constraints) {
            return InformationCard(
              crossAxisCount: _size.width < 650 ? 2 : 4,
              childAspectRatio: _size.width < 650 ? 1.2 : 1,
            );
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return const InformationCard();
          },
        ),
      ],
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dailyDatas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: kSpacing,
        mainAxisSpacing: kSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          MiniInformationWidget(dailyData: dailyDatas[index]),
    );
  }
}
