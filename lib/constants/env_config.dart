import 'package:flutter_dotenv/flutter_dotenv.dart';

final String mainUrl = dotenv.env['MAIN_URL'] ?? '';
final String uatUrl = dotenv.env['UAT_URL'] ?? '';
final String localUrl = dotenv.env['LOCAL_URL'] ?? '';
final String testingUrl = dotenv.env['TESTING_URL'] ?? '';

final String baseUrl = '$testingUrl/api/';

final String login = "${baseUrl}Account/OtpLogin";
final String getProductsListApi = '${baseUrl}Product/GetProducts';
final String getProductById = '${baseUrl}Product/GetProductById';
final String usersEndpoint = '/users';
final String getPersonalDetails = '/getPersonalDetails';
final String managePersonalDetails = "Account/ManageUserDetails";
final String otpLogin = "${baseUrl}Account/otpLogin";
final String otpLoginVerfication = "${baseUrl}Account/otpLoginVerfication";
final String likeUnlikeProductApi = "${baseUrl}Product/LikeUnlikeProduct";
final String likeUnlikeLearningApi =
    "${baseUrl}Product/LikeUnlikeLearningContent";
final String getNotificationsUrl =
    '${baseUrl}PushNotification/GetNotifications';
final String markNotificationsIsRead =
    '${baseUrl}PushNotification/MarkNotificationAsRead';
final String managePurchaseOrderApi = '${baseUrl}Payment/ManagePurchaseOrder';
final String getmyBucketContent = '${baseUrl}Product/MyBucketContent';
final String byPassThePaymentGatewayApi =
    '${baseUrl}Payment/ByPassThePaymentGateway';

//Block user api
final String blockUserApi = '${baseUrl}Blogs/BlockUser';

final String getSubscriptionTopics = '${baseUrl}Account/GetSubscriptionTopics';
final String manageUserDetails = '${baseUrl}Account/ManageUserDetails';
final String getUserDetails = '${baseUrl}Account/GetUserDetails';
final String getFreeTrial = '${baseUrl}Account/GetFreeTrial';
final String activateFreeTrial = '${baseUrl}Account/ActivateFreeTrial';

final String deleteProfileImage = '${baseUrl}Account/RemoveProfileImage';

final String rateProduct = '${baseUrl}Product/RateProduct';
final String getTopGainers = '${baseUrl}Product/GetTopGainers';
final String otpVerification =
    '${baseUrl}Account/OtpLoginVerificationAndGetSubscription';
final String getCoupons = '${baseUrl}Product/GetCoupons';
//GetCouponCode

//NotificationUnread Count api
final String getUnreadNotificationCount =
    '${baseUrl}PushNotification/GetUnreadNotificationCount';
// Notification categories api
final String getProductCategoriesApi = '${baseUrl}Product/GetProductCategories';

final String getProductContentApi = '${baseUrl}Product/GetProductContent';
// new API with some changes
final String getProductContentApiV2 = '${baseUrl}Product/GetProductContentV2';
// PlayList API
final String getPlayListApi = '${baseUrl}Product/GetPlayList';

final String getprofileImage = '${baseUrl}Account/GetProfileImage';
final String logoutApi = '${baseUrl}Account/Logout';

//
//Get ProductImageApi
final String getProductImageApi = '${baseUrl}Product/GetImage';
final String getGetLandscapeImage = '${baseUrl}Product/GetLandscapeImage';

//Blogs
final String getBlogsApi = '${baseUrl}Blogs/GetAll';
final String manageLikeUnlikeByBlogId = '${baseUrl}Blogs/Like';
final String getComments = '${baseUrl}Blogs/GetComments';
final String manageComments = '${baseUrl}Blogs/AddComment';
final String manageBlogPostApi = '${baseUrl}Blogs/Add';
final String getBlogImageApi = '${baseUrl}Blogs/GetImage';
final String getCommentReplyApi = '${baseUrl}Blogs/GetReplies';
final String getBlockedUserApi = '${baseUrl}Blogs/GetBlockedUser';

//add comment reply
final String manageCommentReplyApi = '${baseUrl}Blogs/CommentReply';
//edit blog post
final String editBlogPostByIdApi = '${baseUrl}Blogs/EditBlog';
//edit comments and comment replies
final String editCommentOrReplyApi = '${baseUrl}Blogs/EditCommentOrReply';

//delete blog post
final String deleteBlogPostApi = '${baseUrl}Blogs/DeleteBlog';
final String deleteBlogCommentApi = '${baseUrl}Blogs/DeleteCommentOrReply';
final String getReportReasonapi = '${baseUrl}Blogs/GetReportReason';
final String postReportReasonapi = '${baseUrl}Blogs/ReportBlog';

//dashBoard images
final String getDashBoardImages =
    '${baseUrl}Dashboard/GetAdvertisementImageList';
final String displayImage = '${baseUrl}Dashboard/GetAdvertisementImage';

//disable and enable commentId
final String disableAndEnableBlogComments =
    '${baseUrl}Blogs/DisableBlogComment';

//disable and enable commentId
final String partnerAccountApi = '${baseUrl}Account/ManagePartnerAccount';
final String getPartnerNamesApi = '${baseUrl}Account/GetPartnerNames';
final String getPartnerAccountDetailsApi =
    '${baseUrl}Account/GetDematAccountDetails';

//ads api
final String profileScreenAdvertisementImageUrl =
    '${baseUrl}Dashboard/ProfileScreenAdvertisementImage';
final String getProfileScreenAdvertisementList =
    '${baseUrl}Dashboard/ProfileScreenImageDetails';
// Screener
final String screenerImages = '${baseUrl}Dashboard/GetAdvertisementImage';

//tickets
final String getAllTicketsApi = "${baseUrl}Ticket";
final String getTicketCommentsDetails = "${baseUrl}Ticket/GetTicketDetails";
final String addTicketComments = "${baseUrl}Ticket/AddTicketComment";
final String getSupportMobileApi = '${baseUrl}Ticket/GetSupportMobile';

//coupons
final String validateCouponApi = '${baseUrl}Payment/ValidateCoupon';

//scanners
final String getScannerNotification =
    '${baseUrl}PushNotification/GetScannerNotification';
final String getTodayScannerNotificationApi =
    '${baseUrl}PushNotification/GetTodayScannerNotification';

final String getScannersStrategies = '${baseUrl}Category/GetStrategies';

// Subscription
final String getSubscriptionById = '${baseUrl}Subscription/GetSubscriptionById';

//manage notification
final String manageProductNotificationsApi =
    "${baseUrl}PushNotification/ManageProductNotification";
//Delete Notifications api
final String manageNotificationDeleteApi =
    "${baseUrl}PushNotification/DeleteNotification";

//Check the product validity
final String checkProductValidityApi = "${baseUrl}Other/CheckProductValidity";

// Research

final String getBaskeapi = "${baseUrl}Research/GetBaskets";
final String getComapaniesapi = "${baseUrl}Research/GetCompanies";
final String getReportapi = "${baseUrl}Research/GetCompanyReport";
final String getCommentResearch = "${baseUrl}Research/GetComments";
final String postCommentReserach = "${baseUrl}Research/ManageComment";

//new version api
final String newVersionApi = "${baseUrl}Account/GetNewApiVersionMessage";

final String getLearningMaterial = "${baseUrl}Product/GetLearningMaterial";
final String getLearningContentList =
    "${baseUrl}Product/GetLearningContentList";
final String getLearningContentById =
    "${baseUrl}Product/GetLearningContentById";
final String getLearningContentExamples =
    "${baseUrl}Product/GetLearningContentExamples";

//get Top three Products
final String getTopThreeProductsApi = "${baseUrl}Dashboard/GetTop3Products";

//get subscription topics
final String getMyActiveSubscriptionApi =
    '${baseUrl}Account/GetMyActiveSubscription';

// Update FCm
final String updateFcmapi = '${baseUrl}Account/UpdateFcmToken';

//delete account statement api
final String deleteAccountStatementApi = '${baseUrl}Account/GetDeleteStatement';

//delete account api
final String accountDeleteApi = '${baseUrl}Account/AccountDelete';

//get discount image
final String getDiscountImageurl = '${baseUrl}Account/GetDiscountImage';

// Ticket Image

final String getTicketImages = '${baseUrl}Ticket/GetTicketImage';

// Other
final String other = '${baseUrl}Other';

//Calculate My Future Api
final String calculateMyFutureApi = "${baseUrl}Calculator/CalculateMyFuture";
final String getFuturePlansApi = "${baseUrl}Calculator/GetFuturePlans";

final String calculateSipApi = "${baseUrl}Calculator/CalculateSip";

//Calculate My Risk Reward API
final String calculateRiskRewardApi =
    "${baseUrl}Calculator/CalculateRiskReward";

//Trading Journal Api Test
// final String tradingJournalApiTest = "https://chips.free.beeceptor.com/Tj";

//Trading Journal Api Post
final String tradingJournalApiPost = '${baseUrl}Calculator/CreateTradeJournal';
//Trading Journal Api Get
final String tradingJournalApiGet = '${baseUrl}Calculator/GetPagedTradeJournal';
//Trading Journal Api Delete
final String tradingJournalApiDelete = '${baseUrl}Calculator/Delete';

// Screeners
final String getscreener = '${baseUrl}Screener';
final String getscreenerStockData = '${baseUrl}Screener/GetScreenerData';

///PERFOMANCE
final String getPerformanceApi = '${baseUrl}Performance/GetPerformance';
final String getPerformanceHeaderApi =
    '${baseUrl}Performance/GetPerformanceHeader';

//Market Analysis
final String getPreMarketAnalysisApi = '${baseUrl}PreMarket/GetAllPreMarket';

final String getPreMarketAnalysisApiById =
    '${baseUrl}PreMarket/GetPreMarketById';

// Phoneope webhook
final String phonePeWebHook = '${baseUrl}Other/PhonePe';
//Instamojo webhook
final String instamojoWebhookUrl = '${baseUrl}Payment/InstaMojo';

//Paymet Gateway Pre Request Api [AddPaymentRequest]
final String addPaymentRequestApi = '${baseUrl}Payment/AddPaymentRequest';

//Paymet Gateway Pre Request Api [AddPaymentRequest]
final String getPaymentStatusApi = '${baseUrl}Payment/GetPaymentStatus';

final String getPaymentResponse = '${baseUrl}Other/GetPhonePeResponseStatus';
final String recordPaymentStatus =
    '${baseUrl}Other/PaymentRequestStatus'; // PaymentDetailStatus Renamed to PaymentRequestStatus

final String refreshToken = '${baseUrl}Account/RefreshToken';

///Api version
final String getApiVersionV2Api = '${baseUrl}Other/GetAPIVersionV2';

// Post market by id
final String getPostMarketAnalysisByIdendPoint =
    "${baseUrl}PreMarket/GetPostMarketById";
final String getAlllPostMarketAnalysis =
    "${baseUrl}PreMarket/GetAllPostMarketData";

///Services
final String getServicesApi = "${baseUrl}Dashboard/GetServices";

final String getCommunityDetailsendpoint =
    "${baseUrl}Community/GetCommunityDetails";
final String getCommunityendpoint = "${baseUrl}Community/GetCommunity";
final String postCommunityendpoint = "${baseUrl}Community/CreateBlogCommunity";
final String postAddCommunityendpoint = "${baseUrl}Community/AddComment";
final String getCommentsCommunityendpoint = "${baseUrl}Community/GetComments";
final String postCommentsReplyCommunityendpoint =
    "${baseUrl}Community/CommentReply";
final String getCommentsReplyCommunityendpoint =
    "${baseUrl}Community/GetReplies";
final String getEditCommentsReplyCommunityendpoint =
    "${baseUrl}Community/EditCommentOrReply";
final String deleteCommentsReplyCommunityendpoint =
    "${baseUrl}Community/DeleteCommentOrReply";
final String likeCommunityendpoint = "${baseUrl}Community/LikeBlog";
final String enableDisableCommentCommunityendpoint =
    "${baseUrl}Community/DisableCommunityComment";
final String blockUserCommunityendpoint = "${baseUrl}Community/BlockUser";
final String reportBlogCommunityendpoint = "${baseUrl}Community/ReportBlog";

/// Get total Active Product Counts
final String activeActiveProducts = "${baseUrl}Product/ActiveProducts";

//ManageQuery form Api
final String manageQueryFormApi = '${baseUrl}Product/AddQueryForm';
final String getGetQueryCategoriesApi = '${baseUrl}Product/GetQueryCategories';

//Api For GetInvoicesByMobileUserKey
final String getInvoicesByMobileUserKeyApi =
    '${baseUrl}Payment/GetInvoicesByMobileUserKey';
final String markNotificationAllRed =
    '${baseUrl}PushNotification/MarkAllNotificationAsRead';

final String getPromoAdvertisementList = '${baseUrl}Dashboard/GetPromoPopUp';
