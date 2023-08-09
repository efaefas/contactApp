enum FlagType {
  added,
  updated,
  deleted,
  sync;

  int toJson() => index;
  static FlagType fromJson(int json) => values[json];
}