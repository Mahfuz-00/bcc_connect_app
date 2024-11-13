import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'form_data_state.dart';

// Define the connection request state.
class FormDataState {
  final String? divisionId;
  final String? districtId;
  final String? upazilaId;
  final String? unionId;
  final String? serviceType;
  final String? latlong;
  final int? nttnProvider;
  final String? linkCapacity;
  final String? remark;

  // Page 2 data
  final String? packageName;
  final String? contractDuration;
  final String? discount;
  final String? netPayment;
  final String? paymentMode;
  final String? orderRemark;

  // Constructor for the state, where all fields can be null initially.
  FormDataState({
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.serviceType,
    this.latlong,
    this.nttnProvider,
    this.linkCapacity,
    this.remark,
    this.packageName,
    this.contractDuration,
    this.discount,
    this.netPayment,
    this.paymentMode,
    this.orderRemark,
  });

  // Factory constructor to combine all fields
  factory FormDataState.pageOne({
    required String divisionId,
    required String districtId,
    required String upazilaId,
    required String unionId,
    required String serviceType,
    required String latlong,
    required int nttnProvider,
    required String linkCapacity,
    required String remark,
  }) {
    return FormDataState(
      divisionId: divisionId,
      districtId: districtId,
      upazilaId: upazilaId,
      unionId: unionId,
      serviceType: serviceType,
      latlong: latlong,
      nttnProvider: nttnProvider,
      linkCapacity: linkCapacity,
      remark: remark,
    );
  }

  // Factory constructor to update Page 2 fields
  FormDataState updatePageTwo({
    String? packageName,
    String? contractDuration,
    String? discount,
    String? netPayment,
    String? paymentMode,
    String? orderRemark,
  }) {
    return FormDataState(
      divisionId: this.divisionId,
      districtId: this.districtId,
      upazilaId: this.upazilaId,
      unionId: this.unionId,
      serviceType: this.serviceType,
      latlong: this.latlong,
      nttnProvider: this.nttnProvider,
      linkCapacity: this.linkCapacity,
      remark: this.remark,
      packageName: packageName ?? this.packageName,
      contractDuration: contractDuration ?? this.contractDuration,
      discount: discount ?? this.discount,
      netPayment: netPayment ?? this.netPayment,
      paymentMode: paymentMode ?? this.paymentMode,
      orderRemark: orderRemark ?? this.orderRemark,
    );
  }

  // To check if all required fields are filled
  bool get isComplete =>
      divisionId != null &&
          districtId != null &&
          upazilaId != null &&
          unionId != null &&
          serviceType != null &&
          latlong != null &&
          nttnProvider != null &&
          linkCapacity != null &&
          remark != null;
}
