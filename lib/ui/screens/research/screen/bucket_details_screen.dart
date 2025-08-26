import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/research/reports/research_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/images/custom_images.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/chat_bottom_sheet_components.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/company_type.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/customa_page_shifter.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/last_one_year_sales_components.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/last_ten_years.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class DetailsBucketScreen extends ConsumerStatefulWidget {
  final int basketId;
  final int totalLength;
  final int pageNumber;
  final int id;
  final String ttmpe;
  final String marketCap;
  final int productId;
  const DetailsBucketScreen(
      {super.key,
      required this.basketId,
      required this.id,
      required this.totalLength,
      required this.marketCap,
      required this.ttmpe,
      required this.pageNumber,
      required this.productId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailsBucketScreenState();
}

class _DetailsBucketScreenState extends ConsumerState<DetailsBucketScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  String publicKey = "";
  int currentIndex = 0;
  int pageNumber = 0;
  final GlobalKey keyVal = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      publicKey = await _commonDetails.getPublicKey();
      _checkAndFetch();
      currentIndex = widget.basketId;
      pageNumber = widget.pageNumber;
    });
  }

  Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      readData(widget.basketId, widget.pageNumber);
    }
  }

  Future<void> readData(
    int id,
    int pagenumber,
  ) async {

    await ref.read(researchDetailsProvider.notifier).getReportDataModel({
      "id": id,
      "pageSize": 1,
      "pageNumber": pagenumber,
      "loggedInUser": publicKey,
    });
  }

  void showFullScreenImage(BuildContext context, ImageProvider imageProvider) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
            imageProvider: imageProvider,
            imageUrl: '',
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    final research = ref.watch(researchDetailsProvider);

    final theme = Theme.of(context);

    int length = research.researchDataModel?.companyCount ?? 1;

    String dateString = research.researchDataModel?.publishDate ?? '';
    String formattedDate = "";

    // Check if the dateString is not empty
    if (dateString.isNotEmpty) {
      try {
        formattedDate =
            Utils.formatDateTime(dateTimeString: dateString, format: ddmmyy);

        print(formattedDate);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.primaryColorDark,
              size: 25,
            ),
          ),
          centerTitle: true,
          title: Image.asset(
            kingResearchLogo,
            scale: 3,
          ),
        ),
        body: research.isLoading
            ? const CommonLoaderGif()
            : research.error != null
                ? const NoContentWidget(
                    message: noContentScreenText,
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      readData(widget.basketId, pageNumber);
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 60.0,
                          ), // Reserve space for fixed header
                          child: SingleChildScrollView(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        research.researchDataModel?.symbol ??
                                            "",
                                        style: textH4.copyWith(
                                          fontSize: 13,
                                          decoration: TextDecoration
                                              .underline, // Adds the underline
                                          decorationColor: Colors
                                              .black, // Changes the underline color
                                          decorationThickness:
                                              2.0, // Changes the thickness of the underline
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Wrap(
                                        spacing:
                                            5.0, // Horizontal spacing between items
                                        runSpacing:
                                            5.0, // Vertical spacing between rows
                                        children: List.generate(6, (index) {
                                          final items = [
                                            "$ttmPe : ${widget.ttmpe == "" ? 0.0 : widget.ttmpe}",
                                            "$marketCapInCr${widget.marketCap == "" ? 0.0 : widget.marketCap}",
                                            "$faceValue${research.researchDataModel?.faceValue ?? 0.0}",
                                            "$promotersHolding${research.researchDataModel?.promotersHolding ?? 0.0}",
                                            "$profitGrowth${research.researchDataModel?.profitGrowth ?? 0.0}",
                                            "$currentPrice${research.researchDataModel?.currentPrice ?? 0.0}",
                                          ];

                                          final styles = [
                                            textH4.copyWith(fontSize: 13),
                                            textH5.copyWith(fontSize: 13),
                                            textH5.copyWith(fontSize: 13),
                                            textH5.copyWith(fontSize: 13),
                                            textH5.copyWith(fontSize: 13),
                                            textH5.copyWith(fontSize: 13),
                                          ];

                                          return Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                12, // Equal width for two columns
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    4.0), // Padding inside each item
                                            child: Text(
                                              items[index],
                                              style: styles[index],
                                              maxLines:
                                                  2, // Ensure text doesn’t overflow
                                              overflow: TextOverflow
                                                  .visible, // Truncate long text with ellipsis
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (research.researchDataModel?.description !=
                                      null) ...[
                                    HtmlWidget(
                                      research.researchDataModel?.description ??
                                          "",
                                    ),
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            sharePriceAndVol,
                                            style:
                                                textH5.copyWith(fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (research.researchDataModel?.chartUrl !=
                                      null) ...[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: research.researchDataModel
                                                  ?.chartUrl ==
                                              ''
                                          ? () {}
                                          : () {
                                              showFullScreenImage(
                                                context,
                                                NetworkImage(
                                                  research.researchDataModel
                                                          ?.chartUrl ??
                                                      "",
                                                ),
                                              );
                                            },
                                      child: CustomImages(
                                        imageURL: research
                                                .researchDataModel?.chartUrl ??
                                            "",
                                        aspectRatio: 16 / 9,
                                      ),
                                    )
                                  ],
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (research
                                              .researchDataModel
                                              ?.lastOneYearMonthlyPrices
                                              ?.length !=
                                          0 ||
                                      research.researchDataModel
                                              ?.lastOneYearMonthlyPrices !=
                                          null) ...[
                                    Text(
                                      lastOneYearSales,
                                      style: textH4.copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: width * 0.35,
                                      child: LastOneYearSalesComponents(
                                        comapnayName:
                                            research.researchDataModel?.name ??
                                                "",
                                        researchDataModel:
                                            research.researchDataModel ??
                                                ResearchDataModel(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                  if (research.researchDataModel
                                              ?.lastTenYearSales?.length !=
                                          0 ||
                                      research.researchDataModel
                                              ?.lastTenYearSales !=
                                          null) ...[
                                    Text(
                                      lastTenYearSales,
                                      style: textH4.copyWith(fontSize: 10),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        child: LastTenYearSalesComponents(
                                      researchDataModel:
                                          research.researchDataModel ??
                                              ResearchDataModel(),
                                    )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                  if (research.researchDataModel?.websiteUrl !=
                                      null) ...[
                                    Row(
                                      children: [
                                        const Text(website),
                                        InkWell(
                                            onTap: () async {
                                              "";
                                              await UrlLauncherHelper
                                                  .launchUrlIfPossible(research
                                                          .researchDataModel
                                                          ?.websiteUrl ??
                                                      '');
                                            },
                                            child: Text(
                                              "${research.researchDataModel?.websiteUrl}",
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                  if (research.researchDataModel?.otherUrl !=
                                      null) ...[
                                    GestureDetector(
                                      onTap: research.researchDataModel
                                                  ?.otherUrl ==
                                              ''
                                          ? () {}
                                          : () {
                                              showFullScreenImage(
                                                context,
                                                NetworkImage(research
                                                        .researchDataModel
                                                        ?.otherUrl ??
                                                    ""),
                                              );
                                            },
                                      child: CustomImages(
                                        imageURL: research
                                                .researchDataModel?.otherUrl ??
                                            "",
                                        aspectRatio: 16 / 9,
                                      ),
                                    )
                                  ],
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    companyType,
                                    style: textH4.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (research.researchDataModel != null)
                                    SizedBox(
                                      // height: width * 0.9,
                                      child: CompanyTypeclass(
                                        researchDataModel:
                                            research.researchDataModel ??
                                                ResearchDataModel(),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        lpOtpLongTerm,
                                        style: textH5.copyWith(fontSize: 12),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Fixed name and date container
                        buildTitleBar(theme, research.researchDataModel?.name,
                            formattedDate)
                      ],
                    ),
                  ),
        bottomNavigationBar: research.error != null
            ? const SizedBox.shrink()
            : _buildBottomBar(research.researchDataModel?.commentCount,
                research.researchDataModel?.companyId, length));
  }

  //Widget for  Fixed title and date
  Widget buildTitleBar(theme, stockName, formattedDate) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
          color: theme.shadowColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Align to top
            children: [
              Expanded(
                child: Text(
                  stockName ?? "",
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 15,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3, // Allow wrapping text
                  overflow: TextOverflow.visible, // Wraps text if it's too long
                ),
              ),
              const SizedBox(width: 10), // Spacing between name and date
              Text(
                formattedDate,
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 16,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Widget for BottomAppBar
  Widget _buildBottomBar(commentCount, companyId, length) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomPageShifter(
        commentCount: commentCount ?? 0,
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // Ensure the bottom sheet can scroll when the keyboard is displayed
            builder: (BuildContext context) {
              return ChatBottomSheetComponents(id: companyId ?? 1);
            },
          );
        },
        onBackPressed: () {
          if (pageNumber > 1) {
            --pageNumber;
            readData(currentIndex, pageNumber);
          }
        },
        onForwardPressed: () {
          if (pageNumber < length) {
            ++pageNumber;
            readData(currentIndex, pageNumber);
          }
        },
        canBack: pageNumber > 1 ? true : false,
        canForward: pageNumber < widget.totalLength ? true : false,
        page: pageNumber,
        totalPage: widget.totalLength,
      ),
    );
  }
}
