import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/data_providers/dtos/book_dto.dart';
import '../../../../../core_ui/constants/app_light_colors.dart';
import '../../../../../view_model/book_screen_cubit/book_list_cubit.dart';
import '../../../../../view_model/store_screen_cubit/store_screen_popup_cubit.dart';

import '../../../widgets/neumorphism_button.dart';

class BookStoreItemPopupWidget extends StatelessWidget {
  BookStoreItemPopupWidget(
      {Key? key, required this.bookNetworkObject, this.isBought = false})
      : super(key: key);
  final BookDto bookNetworkObject;
  bool isBought;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Image.network(
                  bookNetworkObject.full_cover_url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              bookNetworkObject.price != 0
                  ? Text(
                      "${bookNetworkObject.price}K",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: isBought ? Colors.grey : Colors.green,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: isBought
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
              const SizedBox(height: 8.0),
              Text(bookNetworkObject.author,
                  style: const TextStyle(
                      color: Color(0xff2a9d8f), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(bookNetworkObject.des),
              const SizedBox(height: 16.0),
              isBought
                  ? Center(
                      child: NeumorphismButton(
                          boderRadius: 8.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'OK',
                            style:
                                TextStyle(color: AppLightColors.kButtonPrimary),
                          )),
                    )
                  : BlocBuilder<StoreScreenPopupCubit, StoreScreenPopupState>(
                      builder: (builderContext, state) {
                        log("state $state");
                        if (state is StoreScreenPopupItemDisplay) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NeumorphismButton(
                                  boderRadius: 8.0,
                                  onPressed: () {
                                    Navigator.pop(builderContext);
                                  },
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                        color: AppLightColors.kButtonPrimary),
                                  )),
                              NeumorphismButton(
                                boderRadius: 8.0,
                                onPressed: () {
                                  BlocProvider.of<StoreScreenPopupCubit>(
                                          builderContext)
                                      .buyABookItem(bookNetworkObject);
                                },
                                child: const Text('GET',
                                    style: TextStyle(
                                        color: AppLightColors.kButtonPrimary)),
                              ),
                            ],
                          );
                        }
                        if (state is StoreScreenPopupItemBuying) {
                          return const Center(
                            child: Text('Buying...'),
                          );
                        }
                        if (state is StoreScreenPopupItemBuyFail) {
                          return Column(
                            children: [
                              const Center(
                                child: Text('Buy Fail'),
                              ),
                              NeumorphismButton(
                                  boderRadius: 8.0,
                                  onPressed: () {
                                    Navigator.pop(builderContext);
                                  },
                                  child: const Text(
                                    'Buy Fail OK',
                                    style: TextStyle(
                                        color: AppLightColors.kButtonPrimary),
                                  )),
                            ],
                          );
                        }
                        if (state is StoreScreenPopupItemBought) {
                          return Center(
                            child: NeumorphismButton(
                                boderRadius: 8.0,
                                onPressed: () {
                                  Navigator.pop(builderContext);
                                  BlocProvider.of<BookListCubit>(builderContext)
                                      .getBookList();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: AppLightColors.kButtonPrimary),
                                )),
                          );
                        }
                        return Center(
                          child: NeumorphismButton(
                              boderRadius: 8.0,
                              onPressed: () {
                                Navigator.pop(builderContext);
                              },
                              child: const Text(
                                'OK Default',
                                style: TextStyle(
                                    color: AppLightColors.kButtonPrimary),
                              )),
                        );
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
