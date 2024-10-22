import 'package:flutter/material.dart';

class ListLecturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khóa Học Toán Lớp 8"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ChapterTile(
            chapterName: "Chương 1: Phép nhân và phép chia các đa thức",
            lessons: [
              LessonTile(
                lessonName: "1. Phân thức đại số",
                description: "Học cách phân tích và giải quyết phân thức.",
              ),
              LessonTile(
                lessonName: "2. Nhân đa thức với đa thức",
                description: "Áp dụng quy tắc nhân cho đa thức.",
              ),
            ],
          ),
          ChapterTile(
            chapterName: "Chương 2: Phân thức đại số",
            lessons: [
              LessonTile(
                lessonName: "1. Bài học về phân thức",
                description: "Nắm vững kiến thức về phân thức đại số.",
              ),
              LessonTile(
                lessonName: "2. Tính chất phân thức",
                description: "Tìm hiểu các tính chất cơ bản của phân thức.",
              ),
            ],
          ),
          ChapterTile(
            chapterName: "Chương 3: Giải phương trình bậc nhất",
            lessons: [
              LessonTile(
                lessonName: "1. Giải phương trình bậc nhất một ẩn",
                description: "Phương pháp giải và ứng dụng.",
              ),
              LessonTile(
                lessonName: "2. Giải phương trình bậc nhất hai ẩn",
                description: "Nâng cao: Hệ phương trình.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChapterTile extends StatelessWidget {
  final String chapterName;
  final List<LessonTile> lessons;

  ChapterTile({required this.chapterName, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          chapterName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        children: lessons,
      ),
    );
  }
}

class LessonTile extends StatelessWidget {
  final String lessonName;
  final String description;

  LessonTile({required this.lessonName, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        lessonName,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(description, style: TextStyle(color: Colors.grey[600])),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.video_label),
            tooltip: 'Xem video',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xem video: $lessonName')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.assignment),
            tooltip: 'Bài tập',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bài tập: $lessonName')),
              );
            },
          ),
        ],
      ),
    );
  }
}
