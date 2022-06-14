import 'dart:developer';

import 'package:hive/hive.dart';

import '../../../core_utils/global_configuration.dart';
import '../../business_models/part_model.dart';
import 'box_name.dart';
import '../hive_objects/part_hive_object/part_hive_object.dart';
import 'base_dao/base_dao.dart';

const _logTag = "PartDAO";

class PartDao implements BaseDao<PartModel, PartHiveObject> {
  static final PartDao _singleton = PartDao._internal();
  PartDao._internal();
  factory PartDao() => _singleton;

  @override
  Future<bool> addItem(HiveObject item, String hiveId) async {
    if (LogEnable) log("$_logTag addItem() item: $item, hiveId: $hiveId");
    try {
      if (LogEnable) log("$_logTag addItem() openBox started");
      await Hive.openBox(BoxName.PART_BOX_NAME);
      if (LogEnable) log("$_logTag addItem() openBox done");
    } catch (e) {
      if (LogEnable) log("$_logTag addItem() ${e.toString()}");
      return false;
    }
    final partBox = Hive.box(BoxName.PART_BOX_NAME);
    if (LogEnable) {
      log("$_logTag addItem() partBox.length: ${partBox.length}");
    }
    await partBox.put(hiveId, item);
    if (LogEnable) log("$_logTag addItem() partBox put done");
    return true;
  }

  @override
  Future<List<PartModel>> getAllItems(List<String> hiveIds) async {
    if (LogEnable) log("$_logTag getAllItems() hiveId: $hiveIds");
    List<PartModel> partInfoModelList = [];
    try {
      await Hive.openBox(BoxName.PART_BOX_NAME);
    } catch (e) {
      return partInfoModelList;
    }
    final partBox = Hive.box(BoxName.PART_BOX_NAME);
    if (LogEnable) log("$_logTag getAllItems() trying get parts...");
    for (String hiveId in hiveIds) {
      if (LogEnable) log("$_logTag getAllItems() partHiveId: $hiveId");
      final partHiveObjectList = partBox.get(hiveId, defaultValue: null);
      if (partHiveObjectList == null) break;
      if (LogEnable) {
        log("$_logTag getAllItems() partHiveObjectList: $partHiveObjectList");
      }
      final partInfoModel =
          PartModel.fromHiveObject(partHiveObjectList as PartHiveObject);
      partInfoModelList.add(partInfoModel);
    }
    if (LogEnable) {
      log("$_logTag getAllItems() get from DB done items.length: ${partInfoModelList.length}");
    }
    return partInfoModelList;
  }

  @override
  Future<PartModel?> getItem(String hiveId) async {
    try {
      await Hive.openBox(BoxName.PART_BOX_NAME);
    } catch (e) {
      return null;
    }
    final partBox = Hive.box(BoxName.PART_BOX_NAME);
    final partHiveObject = partBox.get(hiveId, defaultValue: null);
    return PartModel.fromHiveObject(partHiveObject);
  }

  @override
  Future<bool> removeItem(String hiveId) async {
    try {
      await Hive.openBox(BoxName.PART_BOX_NAME);
    } catch (e) {
      log("$_logTag removeItem() ${e.toString()}");
      return false;
    }
    final partBox = Hive.box(BoxName.PART_BOX_NAME);
    await partBox.delete(hiveId);
    return true;
  }

  @override
  Future<bool> updateItem(HiveObject item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}
