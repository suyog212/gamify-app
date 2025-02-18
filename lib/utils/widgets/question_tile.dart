import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:kGamify/utils/link_classifier.dart';
import 'package:kGamify/utils/widgets/question_audio.dart';
import 'package:kGamify/utils/widgets/question_video.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestionTile extends StatefulWidget {
  final String? questionText;
  final String? questionImg;
  final String? questionNo;
  const QuestionTile(
      {super.key, this.questionText, this.questionImg, this.questionNo});

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  RegExp regExp = RegExp(
      r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText("Q ${widget.questionNo}) ",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold
                ),
            ),
            if (widget.questionText != null || widget.questionText != "")
              Expanded(
                child: HtmlWidget(widget.questionText!,textStyle: TextStyle(
                  fontSize: 14.sp,
                  // fontWeight: FontWeight.bold
                ),),
              ),
          ],
        ),
        const SizedBox(height: 4,),
        FutureBuilder(future: mediaWidget(widget.questionImg ?? ""), builder: (context, snapshot) {
          if (snapshot.hasData)
          {
            return snapshot.data!;
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return const SizedBox();
        },)
      ],
    );
  }

  Future<Widget> mediaWidget(String link) async {
    if(Uri.tryParse(link) == null || !Uri.tryParse(link)!.isAbsolute || link.isEmpty){
      return const SizedBox();
    }
    if(regExp.hasMatch(link)){
      String url = parse(link).getElementsByTagName("a").first.text;
      return QuestionYoutubeVideoPlayer(id: YoutubePlayer.convertUrlToId(url)!);
    } else {
      if(await UrlTypeHelper.getType(link) == UrlType.image){
        return InkWell(
            onTap: () {
              Navigator.push(context, PageRouteBuilder(
                opaque: true,
                barrierDismissible: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.inverseSurface,)),
                    ),
                    extendBodyBehindAppBar: true,
                    body: PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      imageProvider: NetworkImage(link),
                    ),
                  );
                },));
            },
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Image.network(link)));
      }
      if(await UrlTypeHelper.getType(link) == UrlType.audio){
        return QuestionAudio(audioSource: link);
      }
      return QuestionVideo(questionLink: link);
    }
  }
}


