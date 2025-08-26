// ignore_for_file: prefer_initializing_formals

import 'package:research_mantra_official/data/models/user_login_response_model.dart';

class LoginState {
  final UserData? user;
  final Exception? error;
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool isotpSentSuccessfully;
  final bool otpIsVerified;
  final bool isExistingUser;
  final bool retyLimitReached;
  final bool isLoginFailed; // New state for login failure
  final String message;

  final bool  isNotFromOtpScreen;
  LoginState(
      {this.user,
      this.error,
      required this.isUserAuthenticated,
      required this.isLoading,
      required this.isotpSentSuccessfully,
      required this.otpIsVerified,
      required this.isExistingUser,
      required this.retyLimitReached,
      required this.isLoginFailed,
     required  this.isNotFromOtpScreen,
      required this.message // Include isLoginFailed in the constructor
      });

  // Constructors with new state isLoginFailed

  LoginState.otpSent(UserData this.user,bool isNotFromOtpScreen)
      : isUserAuthenticated = false,
        isLoading = false,
        error = null,
        isotpSentSuccessfully = true,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = false,
        isLoginFailed = false,
              isNotFromOtpScreen=isNotFromOtpScreen,
        message = ""; // Initialize isLoginFailed

  // LoginState.success(UserData this.user ,)
  //     : isUserAuthenticated = true,
  //       isLoading = false,
  //       error = null,
  //       isotpSentSuccessfully = true,
  //       otpIsVerified = false,
  //       isExistingUser = false,
  //       retyLimitReached = false,
  //       isLoginFailed = false,
  //        isNotFromOtpScreen=false,
  //       message = "";
  LoginState.loggedOut()
      : user = null,
        error = null,
        isLoading = false,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = false,
        isLoginFailed = false,
         isNotFromOtpScreen=false,
        message = "";
  LoginState.loading({this.user}) // Retain previous user state while loading
      : isLoading = true,
        error = null,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = false,
        isLoginFailed = false,
         isNotFromOtpScreen=false,
        message = "";

  LoginState.failed({required this.message, required this.user})
      : isLoading = false,
        error = null,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = false,
         isNotFromOtpScreen=false,
        isLoginFailed = true;
  LoginState.error(Exception this.error, {required this.user})
      : isLoading = false,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = false,
        isLoginFailed = true,
         isNotFromOtpScreen=false,
        message = "";
  LoginState.otpIsVerified(UserData this.user, bool isExisting)
      : isLoading = false,
        error = null,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = true,
        isExistingUser = isExisting,
        retyLimitReached = false,
        isLoginFailed = false,
         isNotFromOtpScreen=false,
        message = "";

  LoginState.otpRetryLimitReached(this.message)
      : isLoading = false,
        error = null,
        user = null,
        isUserAuthenticated = false,
        isotpSentSuccessfully = false,
        otpIsVerified = false,
        isExistingUser = false,
        retyLimitReached = true,
         isNotFromOtpScreen=false,
        isLoginFailed = true;
}
