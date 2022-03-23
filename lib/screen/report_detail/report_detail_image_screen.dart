import 'package:card_swiper/card_swiper.dart';
import 'package:comaplain/screen/report_detail/report_image.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/report_detail_image/report_detail_image_cubit.dart';
import '../../bloc/report_detail_image/report_detail_image_state.dart';

class ReportDetailImageScreen extends StatefulWidget {
  final int id;
  final String solved;
  ReportDetailImageScreen(this.id, this.solved);

  @override
  _ReportDetailImageScreenState createState() =>
      _ReportDetailImageScreenState();
}

class _ReportDetailImageScreenState extends State<ReportDetailImageScreen> {
  @override
  Widget build(BuildContext context) {
    // ReportDetailImageCubit 호출
    BlocProvider.of<ReportDetailImageCubit>(context)
        .reportDetailImage(widget.id, widget.solved);

    // BlocBuilder 리턴
    return BlocBuilder<ReportDetailImageCubit, ReportDetailImageState>(
      builder: (_, state) {
        if (state is Empty) {
          return Container();
        } else if (state is Error) {
          return Container(
            child: Text(state.message),
          );
        } else if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Loaded) {
          final items = state.images;
          return imageUpDate(context, items);
        }

        return Container();
      },
    );
  }

  Widget imageUpDate(BuildContext context, List<dynamic> items) {
    // items => Report ID 모든 이미지
    // 모든 이미지 URL를 images에 담는다.
    List<String> images = [];
    items.map((e) {
      images.add("http://34.64.175.9/${e.image}");
    }).toList();

    // FlexibleSpaceBar 리턴
    return FlexibleSpaceBar(
      // image가 1개라면 Swiper 사용 x
      background: images.length == 1
          ? InkWell(
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/ReportImageScreen',
                    arguments: ReportImageArguments(
                        startIndex: 0, imageList: images));
              },
            )

          // 이미지가 2개 이상이라면 Swiper 사용 o
          : Swiper(
              loop: false,
              pagination: const SwiperPagination(),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                );
              },
              // 이미지를 눌렀을 때 ReportImageScreen으로 이동(이미지 확대)
              onTap: (int index) {
                Navigator.pushNamed(context, '/ReportImageScreen',
                    arguments: ReportImageArguments(
                        startIndex: index, imageList: images));
              },
            ),
    );
  }
}
