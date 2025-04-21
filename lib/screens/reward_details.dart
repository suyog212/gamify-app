import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RewardDetails extends StatelessWidget {
  const RewardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("Reward"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://www.boat-lifestyle.com/cdn/shop/files/Artboard1_1db915c0-7885-45f6-ac79-48778a221671_600x.png?v=1698387560"))
            ),
            width: double.infinity,
          ),
          const Divider(color: Colors.transparent,),
          const ListTile(
            titleAlignment: ListTileTitleAlignment.top,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(),
            title: Text("Boat",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
          ),
          const AutoSizeText("boAt Rockerz 235 Pro",style: TextStyle(fontWeight: FontWeight.bold),),
          const AutoSizeText("Wireless Bluetooth Neckband with Up To 20 Hours Playback, BEAST™ Mode, ENx™ Technology"),
          const Divider(color: Colors.transparent,),
          const AutoSizeText("Details"),
          const Divider(color: Colors.transparent,),
          const AutoSizeText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore ")
        ],
      ),
    );
  }
}
