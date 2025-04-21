import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:kgamify/utils/widgets/question_video.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
          child: Padding(padding: EdgeInsets.all(16.0), child: HtmlWidget('''
          <iframe width="560" height="315" src="https://www.youtube.com/embed/MqjCIITfCIA?si=y0irvhowv-uJBbCk&amp;controls=0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
          ''')
//           HtmlWidget('''<p>Identify the code segments A and B:</p><pre><code class="language-plaintext">item = queue[front]
// A)
// if(front == rear) {
// 	front = rear = -1;
// }
// else{
// 	front = (front +1)%size;
// }
// B)
// if(front == -1) {
// 	front = rear = 0;
// } else {
// 	rear = (rear +1)%size;
// 	queue[rear] = item;
// }</code></pre>''',
//             buildAsync: true,
//             renderMode: RenderMode.listView,
//           ),
              )),
    );
  }
}

class SignInButton extends StatefulWidget {
  const SignInButton({super.key});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  Set<String> selected = {"signIn"};
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const [
        ButtonSegment(value: "signIn", label: Text("Sign In")),
        ButtonSegment(value: "signUp", label: Text("Sign Up")),
      ],
      showSelectedIcon: false,
      expandedInsets: const EdgeInsets.all(16),
      style: SegmentedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
      selected: selected,
      onSelectionChanged: (value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
