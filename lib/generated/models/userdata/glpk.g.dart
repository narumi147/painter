// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/userdata/glpk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LPSolution _$LPSolutionFromJson(Map json) => $checkedCreate(
      'LPSolution',
      json,
      ($checkedConvert) {
        final val = LPSolution(
          destination: $checkedConvert('destination', (v) => v as int? ?? 0),
          originalItems: $checkedConvert('originalItems',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          totalCost: $checkedConvert('totalCost', (v) => v as int?),
          totalNum: $checkedConvert('totalNum', (v) => v as int?),
          countVars: $checkedConvert(
              'countVars',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => LPVariable<dynamic>.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
          weightVars: $checkedConvert(
              'weightVars',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => LPVariable<dynamic>.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$LPSolutionToJson(LPSolution instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'originalItems': instance.originalItems,
      'totalCost': instance.totalCost,
      'totalNum': instance.totalNum,
      'countVars': instance.countVars.map((e) => e.toJson()).toList(),
      'weightVars': instance.weightVars.map((e) => e.toJson()).toList(),
    };

LPVariable<T> _$LPVariableFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    $checkedCreate(
      'LPVariable',
      json,
      ($checkedConvert) {
        final val = LPVariable<T>(
          name: $checkedConvert('name', (v) => v as int),
          value: $checkedConvert('value', (v) => fromJsonT(v)),
          cost: $checkedConvert('cost', (v) => v as int),
          detail: $checkedConvert(
              'detail',
              (v) => (v as Map?)?.map(
                    (k, e) =>
                        MapEntry(int.parse(k as String), (e as num).toDouble()),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$LPVariableToJson<T>(
  LPVariable<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'name': instance.name,
      'value': toJsonT(instance.value),
      'cost': instance.cost,
      'detail': instance.detail.map((k, e) => MapEntry(k.toString(), e)),
    };

BasicLPParams _$BasicLPParamsFromJson(Map json) => $checkedCreate(
      'BasicLPParams',
      json,
      ($checkedConvert) {
        final val = BasicLPParams(
          colNames: $checkedConvert('colNames',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          rowNames: $checkedConvert('rowNames',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          matA: $checkedConvert(
              'matA',
              (v) => (v as List<dynamic>?)
                  ?.map(
                      (e) => (e as List<dynamic>).map((e) => e as num).toList())
                  .toList()),
          bVec: $checkedConvert('bVec',
              (v) => (v as List<dynamic>?)?.map((e) => e as num).toList()),
          cVec: $checkedConvert('cVec',
              (v) => (v as List<dynamic>?)?.map((e) => e as num).toList()),
          integer: $checkedConvert('integer', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$BasicLPParamsToJson(BasicLPParams instance) =>
    <String, dynamic>{
      'colNames': instance.colNames,
      'rowNames': instance.rowNames,
      'matA': instance.matA,
      'bVec': instance.bVec,
      'cVec': instance.cVec,
      'integer': instance.integer,
    };
