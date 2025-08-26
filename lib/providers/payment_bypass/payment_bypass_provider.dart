import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPaymentByPass_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/payment_bypass/payment_bypass_states.dart';

import 'package:research_mantra_official/utils/toast_utils.dart';

class PaymentByPassProvider extends StateNotifier<PaymentByPassState> {
  PaymentByPassProvider(this._byPassRepository)
      : super(PaymentByPassState.init());

  final IPaymentGateWayByPassRepository _byPassRepository;

  //Method to getCouponCodeStatus
  Future<void> getCouponCodeCheckStatus(String mobileUserKey, int productId,
      String couponCode, String checkStatus) async {
    try {
      if (state.paymentResponseModel != null) {
        state = PaymentByPassState.loading();
      }

      final response = await _byPassRepository.byPassTheGateWay(
          mobileUserKey, productId, couponCode, checkStatus);
      state = PaymentByPassState.loaded(response, false, null);
    } catch (e) {
      state = PaymentByPassState.error(e);
    }
  }

  //Method to get getCouponCodeStatus
  Future<bool> applyCoucponCode(
      mobileUserKey, productId, couponCode, checkStatus) async {
    try {
      if (state.paymentResponseModel != null) {
        state = PaymentByPassState.loading();
      }
      final response = await _byPassRepository.byPassTheGateWay(
          mobileUserKey, productId, couponCode, checkStatus);

      if (response.status) {
        final productData = jsonDecode(response.data);

        final PaymentResponseModel paymentResponseModel =
            PaymentResponseModel.fromJson(productData[0]);

        state = PaymentByPassState.loaded(response, true, paymentResponseModel);

        return true;
      } else {
        ToastUtils.showToast("InValid CouponCode", "");
        state = PaymentByPassState.loaded(
            response, false, state.paymentResponseModel);
        return false;
      }
    } catch (e) {
      state = PaymentByPassState.error(e);
      ToastUtils.showToast(somethingWentWrong, "");
      return false;
    }
  }

  //Method to getCouponCodeLink
  Future<void> getCouponCodeLink(
      mobileUserKey, productId, couponCode, checkStatus) async {
    try {
      if (state.paymentResponseModel != null) {
        state = PaymentByPassState.loading();
      }
      final response = await _byPassRepository.byPassTheGateWay(
          mobileUserKey, productId, couponCode, checkStatus);
      if (response.status) {
        ToastUtils.showToast(couponCodeSentToText, "");
        state = PaymentByPassState.loaded(response, false, null);
      }
    } catch (e) {
      state = PaymentByPassState.error(e);
      ToastUtils.showToast(somethingWentWrong, "");
    }
  }
}

final paymentByPassStateProvider =
    StateNotifierProvider<PaymentByPassProvider, PaymentByPassState>((ref) {
  final IPaymentGateWayByPassRepository paymentByPassDetails =
      getIt<IPaymentGateWayByPassRepository>();

  return PaymentByPassProvider(paymentByPassDetails);
});
