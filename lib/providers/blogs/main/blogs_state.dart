import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';

// Define a new state class for managing blog posts
class BlogsState {
  final List<Blogs?> blogApiResponseModel;
  final bool isLoading;
  final bool isLoadingMore;
  final dynamic error;
  final bool isAddingPost;
  final bool isDeletePost;
  final bool isEditPost;
  final bool isUserBlock;


   bool? isBeingReported;

  BlogsState({
    required this.blogApiResponseModel,
    required this.isLoading,
    required this.isLoadingMore,
    required this.error,
    required this.isAddingPost,
    required this.isDeletePost,
    required this.isUserBlock,

    required this.isEditPost,

   required this.isBeingReported,
  });

  // Helper methods to create different instances of the state
  factory BlogsState.initial() {
    return BlogsState(
        blogApiResponseModel: [],
        isLoading: true,
        isLoadingMore: false,
        error: null,

        isAddingPost: false,
        isDeletePost: false,
        isBeingReported: false,
        isEditPost: false, isUserBlock: false);
  }

  factory BlogsState.loading(List<Blogs?> blogs,) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: true,
        isLoadingMore: false,
        error: null,

        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false,
        isUserBlock: false,
          isBeingReported: false,
        );
  }

  factory BlogsState.success(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
        error: null,
          isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false,
        
          isBeingReported: false,
        );
  }

  factory BlogsState.delete(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
        error: null,
              isUserBlock: false,
        isAddingPost: false,
        isDeletePost: true,
        isEditPost: false,
        
        
          isBeingReported: false,);
  }

  factory BlogsState.error(dynamic error,) {
    return BlogsState(
        blogApiResponseModel: [],
        isLoading: false,
        isLoadingMore: false,
        error: error,
        isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false,
        
          isBeingReported: false,
        );
  }

  factory BlogsState.loadMore(List<Blogs?> blogs,) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: true,
        error: null,
              isUserBlock: false,
            isBeingReported: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }

  factory BlogsState.progress(List<Blogs?> blogs,) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
        error: null,
              isUserBlock: false,
        isAddingPost: true,
        isDeletePost: false,
          isBeingReported: false,
        isEditPost: false);
  }

  factory BlogsState.isEdit(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
         isBeingReported: false,
        error: null,
              isUserBlock: false,
        isAddingPost: true,
        isDeletePost: false,
        isEditPost: true);
  }

   factory BlogsState.isDelete(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
        error: null,
              isUserBlock: false,
           isBeingReported: false,
        isAddingPost: false,
        isDeletePost: true,
        isEditPost: true);
  }
   factory BlogsState.getReport(List<Blogs?> blogs, List<GetReportReasonModel> reportResponseModel) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
         isBeingReported: false,
        error: null,
            isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }
   factory BlogsState.postReport(List<Blogs?> blogs, ) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
          isBeingReported: false,
        isLoadingMore: false,
        error: null,
        isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }
   factory BlogsState.postReportLoading(List<Blogs?> blogs, bool isBeingReported) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
          isBeingReported: isBeingReported,
        error: null,
          isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }
   factory BlogsState.getReportLoading(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
          isBeingReported: false,
        error: null,
        isUserBlock: false,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }

   factory BlogsState.isUserBlock(List<Blogs?> blogs) {
    return BlogsState(
        blogApiResponseModel: blogs,
        isLoading: false,
        isLoadingMore: false,
          isBeingReported: false,
        error: null,
        isUserBlock: true,
        isAddingPost: false,
        isDeletePost: false,
        isEditPost: false);
  }
}
