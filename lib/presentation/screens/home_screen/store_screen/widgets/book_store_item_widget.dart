import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toeic_quiz2/view_model/book_screen_cubit/book_list_cubit.dart';
import 'package:flutter_toeic_quiz2/view_model/store_screen_cubit/store_screen_popup_cubit.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../data/business_models/book_info_model.dart';
import 'book_store_item_popup_widget.dart';

class BookStoreItemWidget extends StatefulWidget {

  final BookInfoModel bookInfoModel;
  bool isBought;
  BookStoreItemWidget(
      {Key? key, required this.bookInfoModel, this.isBought = false})
      : super(key: key);

  @override
  State<BookStoreItemWidget> createState() => _BookStoreItemWidgetState();
}

class _BookStoreItemWidgetState extends State<BookStoreItemWidget> {
  String bookCoverLink = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateImageCover();
  }

  void updateImageCover() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      bookCoverLink = widget.bookInfoModel.networkUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     CupertinoPageRoute(
        //       builder: (context) => BookDetailScreen(
        //         toeicBook: widget.toeicBook,
        //         bookCoverLink: bookCoverLink,
        //         bought: widget.bought,
        //       ),
        //     ));
        //BlocProvider.of<StoreScreenCubit>(context).displayBookItemPopup();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                scrollable: true,
                title: Center(child: Text(widget.bookInfoModel.title)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
                content: BlocProvider.value(
                  value: StoreScreenPopupCubit()..displayBookItemPopup(),
                  child: BlocProvider.value(
                    value: BlocProvider.of<BookListCubit>(context),
                    child: BookStoreItemPopupWidget(
                      bookInfoModel: widget.bookInfoModel,
                      isBought: widget.bookInfoModel.isBought,
                    ),
                  ),
                ),
              );
            });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: bookCoverLink == ''
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 200,
                            child: Center(child: Text('Loading...'))),
                      ))
                    : Image.network(
                        bookCoverLink,
                        fit: BoxFit.cover,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.kPaddingDefault),
                  Text(
                    widget.bookInfoModel.title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: AppDimensions.kPaddingDefault),
                  widget.bookInfoModel.price != 0
                      ? Text(
                          "${widget.bookInfoModel.price}K",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: widget.isBought
                                ? const Text(
                                    'You already get it',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  )
                                : const Text(
                                    'Free',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
