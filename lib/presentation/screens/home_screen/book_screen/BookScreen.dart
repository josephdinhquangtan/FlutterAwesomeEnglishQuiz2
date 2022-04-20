import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/book_info_model.dart';
import '../../../../view_model/book_screen_view_model/book_list_cubit.dart';
import 'widgets/book_item_widget.dart';

final List<BookItemWidget> bookItems = [];
final bookListCubit = BookListCubit();

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool listItemIsUpdated = false;

  @override
  void initState() {
    super.initState();
    bookListCubit.getBookList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookListCubit>(
      create: (context) => bookListCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BOOKS'.toUpperCase()),
        ),
        body: BlocConsumer<BookListCubit, BookListState>(
          listener: (context, state) {
            if (state is BookListLoaded) {
              final bookListInfo = state.bookListModel;
              bookItems.clear();
              for (BookInfoModel bookInfo in bookListInfo) {
                bookItems.add(BookItemWidget(toeicBook: bookInfo));
              }
            }
          },
          builder: (context, state) {
            if (state is BookListLoaded) return _buildList();
            return const Center(
              child: Text('Loading...'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: bookItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppDimensions.kPaddingDefault,
            right: AppDimensions.kPaddingDefault,
            top: index == 0 ? AppDimensions.kPaddingDefault / 2 : 0.0,
            bottom: index == bookItems.length - 1
                ? AppDimensions.kPaddingDefault / 2
                : 0.0,
          ),
          child: bookItems[index],
        );
      },
    );
  }
}
