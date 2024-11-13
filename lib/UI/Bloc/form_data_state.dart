part of 'form_data_cubit.dart';

class FormDataCubit extends Cubit<FormDataState> {
  // Constructor to initialize the cubit with a default state.
  FormDataCubit() : super(FormDataState());

  // Method to update page one fields
  void updatePageOneData({
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
    // Print the data to check if it's being saved correctly
    print('Page 1 Data:');
    print('Division ID: $divisionId');
    print('District ID: $districtId');
    print('Upazila ID: $upazilaId');
    print('Union ID: $unionId');
    print('Service Type: $serviceType');
    print('LatLong: $latlong');
    print('NTTN Provider: $nttnProvider');
    print('Link Capacity: $linkCapacity');
    print('Remark: $remark');

    final updatedState = FormDataState.pageOne(
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
    emit(updatedState); // Emit the updated state
  }

  // Method to update page two fields
  void updatePageTwoData({
    String? packageName,
    String? contractDuration,
    String? discount,
    String? netPayment,
    String? paymentMode,
    String? orderRemark,
  }) {
    final updatedState = state.updatePageTwo(
      packageName: packageName,
      contractDuration: contractDuration,
      discount: discount,
      netPayment: netPayment,
      paymentMode: paymentMode,
      orderRemark: orderRemark,
    );
    emit(updatedState); // Emit the updated state with page two data
  }

  // Method to check if the connection request is complete
  bool get isRequestComplete => state.isComplete;
}
