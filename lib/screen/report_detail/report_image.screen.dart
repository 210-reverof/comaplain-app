import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class ReportImageArguments {
  final int startIndex;
  final List imageList;
  ReportImageArguments({required this.startIndex, required this.imageList});
}

class ReportImageScreen extends StatefulWidget {
  const ReportImageScreen({Key? key}) : super(key: key);

  @override
  _ReportImageScreenState createState() => _ReportImageScreenState();
}

class _ReportImageScreenState extends State<ReportImageScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ReportImageArguments;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ]),
        body: Center(
          // 이미지가 2개 이상이 아니라면 그냥 이미지만!
          child: args.imageList.length == 1
              ? Image.network(
                  args.imageList[0],
                  fit: BoxFit.cover,
                )

              // 이미지가 2개 이상이라면 Swiper 사용 o
              : Swiper(
                  index: args.startIndex,
                  loop: false,
                  pagination: const SwiperPagination(),
                  itemCount: args.imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      args.imageList[index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
        ));
  }
}
