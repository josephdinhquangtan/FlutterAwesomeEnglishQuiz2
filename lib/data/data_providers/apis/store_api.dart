import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_toeic_quiz2/data/data_providers/dtos/book_dto.dart';
import 'package:flutter_toeic_quiz2/data/data_providers/dtos/part_dto.dart';
import 'package:flutter_toeic_quiz2/data/data_providers/dtos/parts_dto/part_one_dto.dart';
import 'package:flutter_toeic_quiz2/data/data_providers/dtos/parts_dto/part_two_dto.dart';
import 'package:flutter_toeic_quiz2/data/data_providers/dtos/test_dto.dart';

import '../../download_manager/download_constant.dart';
import '../dtos/parts_dto/part_three_dto.dart';

class StoreApi {
  static final StoreApi _singleton = StoreApi._internal();
  StoreApi._internal();
  factory StoreApi() => _singleton;

  static final List<BookDto> _bookDtoList = [];

  Future<List<PartOneDto>> getPartOneListNetwork(String path) async {
    final List<PartOneDto> partOneDtoList = [];
    final String jsonString = await _getRawJsonFile(path);
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final partTwoDto = PartOneDto.fromMap(jsonMap);
      partOneDtoList.add(partTwoDto);
    }
    return partOneDtoList;
  }

  Future<List<PartTwoDto>> getPartTwoListNetwork(String path) async {
    final List<PartTwoDto> partTwoDtoList = [];
    final String jsonString = await _getRawJsonFile(path);
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final partTwoDto = PartTwoDto.fromMap(jsonMap);
      partTwoDtoList.add(partTwoDto);
    }
    return partTwoDtoList;
  }

  Future<List<PartThreeDto>> getPartThreeListNetwork(String path) async {
    final List<PartThreeDto> partThreeDtoList = [];
    final String jsonString = await _getRawJsonFile(path);
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final partThreeDto = PartThreeDto.fromMap(jsonMap);
      partThreeDtoList.add(partThreeDto);
    }
    return partThreeDtoList;
  }

  Future<List<PartDto>> getPartListNetwork(String path) async {
    final List<PartDto> partDto = [];
    final String jsonString = await _getRawJsonFile(path);
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final partNetworkObject = PartDto.fromMap(jsonMap);
      partDto.add(partNetworkObject);
    }
    return partDto;
  }

  Future<List<TestDto>> getTestListNetwork(String path) async {
    final List<TestDto> testDto = [];
    final String jsonString = await _getRawJsonFile(path);
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final testNetworkObject = TestDto.fromMap(jsonMap);
      testDto.add(testNetworkObject);
    }
    return testDto;
  }

  Future<List<BookDto>> getBookListNetwork() async {
    if (_bookDtoList.isEmpty) {
      await _updateNetworkBookInfoModelList();
    }
    return _bookDtoList;
  }

  Future<String> _getDownloadUrlFromPath(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    return await ref.getDownloadURL();
  }

  Future<void> _updateNetworkBookInfoModelList() async {
    _bookDtoList.clear();
    final String jsonString = await _getRawBooksJsonFile();
    List<dynamic> jsonMapList = jsonDecode(jsonString);
    for (var jsonMap in jsonMapList) {
      final bookDto = BookDto.fromMap(jsonMap);
      bookDto.full_cover_url = await _getDownloadUrlFromPath(bookDto.cover_url);
      _bookDtoList.add(bookDto);
    }
  }

  static Future<String> _getRawBooksJsonFile() async {
    const path = DownloadConstant.BooksJsonFileBaseRelativePath;
    final ref = FirebaseStorage.instance.ref(path);
    final Uint8List? downloadedData = await ref.getData();
    final res = utf8.decode(downloadedData!);
    return res;
  }

  static Future<String> _getRawJsonFile(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final Uint8List? downloadedData = await ref.getData();
    final res = utf8.decode(downloadedData!);
    return res;
  }
}