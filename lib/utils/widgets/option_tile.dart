import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:kGamify/utils/link_classifier.dart';
import 'package:kGamify/utils/widgets/question_video.dart';
import 'package:photo_view/photo_view.dart';

class OptionTile extends StatefulWidget {
  final String? optionNo;
  final String? optionText;
  final String? optionImg;
  const OptionTile({super.key, this.optionNo, this.optionText, this.optionImg});

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  RegExp regExp = RegExp(
      r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(widget.optionNo!),
              if(widget.optionText != null || widget.optionText != "") Expanded(
                child: HtmlWidget(widget.optionText!,textStyle: TextStyle(
                  fontSize: 14.sp,
                ),
                ),
              ),
            ],
          ),
          FutureBuilder(future: mediaWidget(widget.optionImg ?? ""), builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            if (snapshot.hasData)
            {
              return snapshot.data!;
            }
            return const SizedBox();
          },)
          // if(widget.optionImg != null || widget.optionImg!.isEmpty || !Uri.tryParse(widget.optionImg!)!.isAbsolute)
          //   mediaWidget(widget.optionImg!)
            // InkWell(
            // onTap: () {
            //   Navigator.push(context, PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) {
            //     return Scaffold(
            //       appBar: AppBar(
            //         backgroundColor: Colors.transparent,
            //         leading: IconButton(onPressed: () {
            //           Navigator.pop(context);
            //         }, icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.surface,)),
            //       ),
            //       extendBodyBehindAppBar: true,
            //       body: PhotoView(
            //         imageProvider: NetworkImage(widget.optionImg!),
            //       ),
            //     );
            //   },));
            // },
            //   child: Image.network(widget.optionImg!,height: kToolbarHeight * 1.5,)),
        ],
      ),
    );
  }

  Future<Widget> mediaWidget(String link) async {
    if(Uri.tryParse(link) == null || !Uri.tryParse(link)!.isAbsolute || link.isEmpty){
      return const SizedBox();
    }
    if(regExp.hasMatch(link)){
      String url = parse(link).getElementsByTagName("a").first.text;
      return QuestionYoutubeVideoPlayer(id: url);
    } else {
      if(await UrlTypeHelper.getType(link) == UrlType.image){
        return InkWell(
            onTap: () {
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.surface,)),
                    ),
                    extendBodyBehindAppBar: true,
                    body: PhotoView(
                      imageProvider: NetworkImage(link),
                    ),
                  );
                },));
            },
            child: Image.network(link,height: kToolbarHeight * 3.5,));
      }
      return QuestionVideo(questionLink: link);
    }
  }
}
