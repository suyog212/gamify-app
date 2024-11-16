import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ChampionShipInfoSkeleton extends StatelessWidget {
  const ChampionShipInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: const Border.fromBorderSide(BorderSide(color: Colors.grey, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                "Quick Hit",
                style: TextStyle(color: Colors.red),
              ),
              Icon(Icons.info_outline_rounded)
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Mind Marathon",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: const Text("Programming"),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                Text(
                  " Upcoming",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                "4 Questions | 20 mins",
                style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
              ),
              // Icon(Icons.auto_graph),
              // Spacer(),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.person),
                  Text("5K"),
                ],
              ),
            ],
          ),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverflowBar(
                    children: [
                      Icon(Icons.school_outlined),
                      VerticalDivider(),
                      AutoSizeText("B.Tech")
                    ],
                  ),
                  Divider(
                    height: 2,
                  ),
                  OverflowBar(
                    children: [
                      Icon(Icons.calendar_month),
                      VerticalDivider(),
                      OverflowBar(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text("Starts : "), Text("Ends   : ")],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text("Mar Wed 20 12:00 PM"), Text("Mar Wed 20 12:00 PM")],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}