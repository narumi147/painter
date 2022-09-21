import '../../utils/utils.dart';
import '_helper.dart';

part '../../generated/models/userdata/glpk.g.dart';

@JsonSerializable()
class LPSolution {
  /// 0-glpk plan, 1-efficiency
  int destination = 0;
  List<int> originalItems;
  int? totalCost;
  int? totalNum;

  //int
  List<LPVariable> countVars;

  //double
  List<LPVariable> weightVars;

  @JsonKey(ignore: true)
  BasicLPParams? params;

  LPSolution({
    int? destination = 0,
    List<int>? originalItems,
    this.totalCost,
    this.totalNum,
    List<LPVariable>? countVars,
    List<LPVariable>? weightVars,
  })  : destination = destination ?? 0,
        originalItems = originalItems ?? [],
        countVars = countVars ?? [],
        weightVars = weightVars ?? [];

  void clear() {
    totalCost = null;
    totalNum = null;
    countVars.clear();
  }

  void sortCountVars() {
    countVars.sort((a, b) => b.value - a.value);
  }

  void sortWeightVars() {
    weightVars.sort((a, b) =>
        Maths.sum(b.detail.values).compareTo(Maths.sum(a.detail.values)));
  }

  List<int> getIgnoredKeys() {
    List<int> items = [];
    for (final v in countVars) {
      items.addAll(v.detail.keys);
    }
    return originalItems.where((e) => !items.contains(e)).toList();
  }

  factory LPSolution.fromJson(Map<String, dynamic> data) =>
      _$LPSolutionFromJson(data);

  Map<String, dynamic> toJson() => _$LPSolutionToJson(this);
}

@JsonSerializable()
class LPVariable<T> {
  int name;
  T value;
  int cost;

  /// total item-num statistics from [value] times of quest [name]
  // @_Converter()
  Map<int, double> detail;

  LPVariable({
    required this.name,
    required this.value,
    required this.cost,
    Map<int, double>? detail,
  }) : detail = detail ?? {};

  factory LPVariable.fromJson(Map<String, dynamic> data) =>
      _$LPVariableFromJson<T>(data, _fromJsonT);

  Map<String, dynamic> toJson() => _$LPVariableToJson<T>(this, _toJsonT);
}

T _fromJsonT<T>(Object? data) => data as T;

Object? _toJsonT<T>(T value) => value.toString();

/// min c'x
///   Ax>=b
@JsonSerializable()
class BasicLPParams {
  List<int> colNames; //n
  List<int> rowNames; //m
  List<List<num>> matA; // m*n
  List<num> bVec; //m
  List<num> cVec; //n
  bool integer;

  BasicLPParams({
    List<int>? colNames,
    List<int>? rowNames,
    List<List<num>>? matA,
    List<num>? bVec,
    List<num>? cVec,
    bool? integer,
  })  : colNames = colNames ?? [],
        rowNames = rowNames ?? [],
        matA = matA ?? [],
        bVec = bVec ?? [],
        cVec = cVec ?? [],
        integer = integer ?? false;

  List<num> getCol(int index) {
    return matA.map((e) => e[index]).toList();
  }

  void addRow(int rowName, List<num> rowOfA, num b) {
    rowNames.add(rowName);
    matA.add(rowOfA);
    bVec.add(b);
  }

  void removeCol(int index) {
    colNames.removeAt(index);
    cVec.removeAt(index);
    matA.forEach((row) {
      row.removeAt(index);
    });
  }

  void removeRow(int index) {
    rowNames.removeAt(index);
    matA.removeAt(index);
    bVec.removeAt(index);
  }

  void removeInvalidCells() {
    for (int row = rowNames.length - 1; row >= 0; row--) {
      if (bVec[row] <= 0 || matA[row].every((e) => e == 0)) {
        removeRow(row);
      }
    }
    for (int col = colNames.length - 1; col >= 0; col--) {
      if (matA.every((rowData) => rowData[col] == 0)) {
        removeCol(col);
      }
    }
  }

  factory BasicLPParams.fromJson(Map<String, dynamic> data) =>
      _$BasicLPParamsFromJson(data);

  Map<String, dynamic> toJson() => _$BasicLPParamsToJson(this);
}
