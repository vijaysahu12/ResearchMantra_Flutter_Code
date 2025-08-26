//Manage the Notification Count State
class NotificationCountState {
  final bool isLoading;
  final dynamic data;
  final dynamic error;

  NotificationCountState(
      {required this.data, required this.error, required this.isLoading});

//Initail State
  factory NotificationCountState.initial() => NotificationCountState(
        data: null,
        error: null,
        isLoading: false,
      );

  //Loading State
  factory NotificationCountState.loading() => NotificationCountState(
        data: null,
        error: null,
        isLoading: true,
      );

//Success State
  factory NotificationCountState.success(dynamic data) =>
      NotificationCountState(
        data: data,
        error: null,
        isLoading: false,
      );

//Error State
  factory NotificationCountState.error(dynamic error) => NotificationCountState(
        data: null,
        error: error,
        isLoading: false,
      );
}
