import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/blogs/main/report/report_state.dart';

class ReportStateNotifier extends StateNotifier<ReportState> {
  ReportStateNotifier(this._blogRepository) : super(ReportState.initial());

  final IGetBlogRepository _blogRepository;

  // Function for getting all blog posts

  Future<void> getReport() async {
    try {
      state = ReportState.loading();

      final getAllReport = await _blogRepository.getReportReason();

      state = ReportState.loaded(getAllReport);
    } catch (e) {
      state = ReportState.error(
        e.toString(),
      );
    }
  }

  // Future<void> postReportReasonBlog({
  //   required String blogId,
  //   required String reportedby,
  //   required String reasonId,
  // }) async {
  //   try {
  //     state = ReportState.postReportLoading(
  //         state.blogApiResponseModel, state.reportResponseModel, true);
  //     final updatedBlogList = List<Blogs?>.from(state.blogApiResponseModel);
  //     final statusCode = await _blogRepository.postReportBlog(
  //         blogId: blogId, reportedby: reportedby, reasonId: reasonId);

  //     if (statusCode == 200) {
  //       int index = state.blogApiResponseModel
  //           .indexWhere((element) => element?.objectId == blogId);

  //       updatedBlogList[index] =
  //           updatedBlogList[index]?.copyWith(isUserReported: true);
  //     }

  //     state =
  //         ReportState.postReport(updatedBlogList, state.reportResponseModel);
  //   } catch (e) {
  //     state = ReportState.error(e.toString());
  //   }
  // }
}

// Provider for managing the states
final getReportNotifierProvider =
    StateNotifierProvider<ReportStateNotifier, ReportState>((ref) {
  final IGetBlogRepository getReportRepository = getIt<IGetBlogRepository>();
  return ReportStateNotifier(getReportRepository);
});
