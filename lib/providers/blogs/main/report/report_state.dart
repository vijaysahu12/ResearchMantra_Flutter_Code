import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';


class ReportState {
  final dynamic error;
  final bool isLoading;

   final List<GetReportReasonModel> ?reportResponseModel;
  ReportState({
    required this.isLoading,
    this.error,
    this.reportResponseModel,
  });

  factory ReportState.initial() =>
      ReportState(isLoading: false, );
  factory ReportState.loading() => ReportState(
        isLoading: true,
      );

  factory ReportState.loaded(
      List<GetReportReasonModel> ?reportResponseModel) =>
      ReportState(
        isLoading: false,
        reportResponseModel: reportResponseModel,
      );
  factory ReportState.error(dynamic error) => ReportState(
        isLoading: false,
        error: error,
        reportResponseModel: null,
      );
}
