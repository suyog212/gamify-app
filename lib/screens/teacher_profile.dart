import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TeacherProfile extends StatelessWidget {
  final String? teacherId;
  final String? uniqueId;
  final String? status;
  final String? teacherName;
  final String? username;
  final String? email;
  final String? password;
  final String? phone;
  final String? institute;
  final String? department;
  final String? uploadImg;
  final Null verifyToken;
  final String? createdAt;
  const TeacherProfile({super.key, this.teacherId, this.uniqueId, this.status, this.teacherName, this.username, this.email, this.password, this.phone, this.institute, this.department, this.uploadImg, this.verifyToken, this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: MediaQuery.sizeOf(context).width * 0.15,
            ),
            const Divider(color: Colors.transparent,),
            AutoSizeText(teacherName ?? "",style: Theme.of(context).textTheme.titleLarge,textAlign: TextAlign.center,),
            AutoSizeText(email ?? "",textAlign: TextAlign.center,),
            AutoSizeText("$department,$institute",textAlign: TextAlign.center,),
            const Divider(),
            AutoSizeText("Recent championships",style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ),
    );
  }
}
