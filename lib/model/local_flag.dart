import 'package:mobile/model/types/flag_type.dart';
import 'package:mobile/util/utility.dart';

class LocalFlag {
  late String flagId;
  late String? waitFor;
  late FlagType flagType;
  late DateTime flagDate;

  createGet(){
    flagId = Utility.getRandomInt(1, 9999999).toString();
    flagType = FlagType.sync;
    flagDate = DateTime.now();
  }

  synced(){
    flagType = FlagType.sync;
    flagDate = DateTime.now();
  }

  updated(){
    if(flagType == FlagType.added || flagType == FlagType.deleted) return;
    flagType = FlagType.updated;
    flagDate = DateTime.now();
  }

  deleted(){
    flagType = FlagType.deleted;
    flagDate = DateTime.now();
  }

  added(){
    flagType = FlagType.deleted;
    flagDate = DateTime.now();
  }

  LocalFlag.created() {
    flagId = Utility.getRandomInt(1, 9999999).toString();
    flagType = FlagType.added;
    flagDate = DateTime.now();
  }

  LocalFlag.fromJson(Map<String, dynamic> json) {
    flagId = json['flagId'] ?? Utility.getRandomInt(1, 9999999).toString();
    flagDate = json['flagDate'] != null ? DateTime.parse(json['flagDate']) : DateTime.now();
    if(json['flagType'] != null){
      flagType = FlagType.fromJson(json['flagType']);
    } else {
      flagType = FlagType.sync;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flagId'] = flagId;
    data['flagType'] = flagType.toJson();
    data['flagDate'] = flagDate.toString();
    return data;
  }
}