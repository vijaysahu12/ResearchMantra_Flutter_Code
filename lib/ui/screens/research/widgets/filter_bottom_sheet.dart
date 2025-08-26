import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/research/filter_data_model.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class FilterBottomSheet extends StatefulWidget {
  final Future<void> Function({
    String? primaryKeyData,
    String? secondaryLKey,
    String? searchTextData,
  }) getCompaniesData;

  const FilterBottomSheet({super.key, required this.getCompaniesData});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool active = false;
  int currentFieldIndex = 0;
  String? extractFilterData(List<FilterData> filterData) {
    for (int i = 0; i < filterData.length; i++) {
      bool value = filterData[i].isSelected ?? false;

      if (value) {
        return filterData[i].displayName == all ? null : filterData[i].code;
      }
    }

    return null;
  }

  bool containsTrue(List<FilterData> filterData) {
    for (int i = 0; i < filterData.length; i++) {
      bool value = filterData[i].isSelected ?? false;

      if (value) {
        return true;
      }
    }

    return false;
  }

  late FilterDataModel filterData;
  late final TextEditingController searchController;
  

  FilterDataModel assign() {
    List<FilterData> filterDataOne = [
      FilterData(
        displayName: all,
        code: allMarketCap,
        isSelected: false,
      ),
      FilterData(
        displayName: lessThan500Cr,
        code: lessThan500,
        isSelected: false,
      ),
      FilterData(
        displayName: greaterThan500Cr,
        code: greaterThan500,
        isSelected: false,
      ),
    ];
    List<FilterData> filterDataTwo = [
      FilterData(
        displayName: all,
        code: allPe,
        isSelected: false,
      ),
      FilterData(
        displayName: lessThan40,
        code: lessThan40Code,
        isSelected: false,
      ),
      FilterData(
        displayName: greaterThan40,
        code: greaterThan40Code,
        isSelected: false,
      ),
    ];

    List<Data> dataM = [
      Data(
        name: marketCap,
        filterData: filterDataOne,
      ),
      Data(name: ttmPe, filterData: filterDataTwo)
    ];

    return FilterDataModel(data: dataM);
  }

  @override
  void initState() {
    super.initState();
    filterData = assign();
   
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 20),
                    child: Text(
                      filters,
                      style: textH4,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Theme.of(context).shadowColor,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                // fieldName.length,

                                filterData.data?.length ?? 0,
                                (index) => _selectedContainers(
                                    context: context,
                                    onTap: () {
                                      setState(() {
                                        currentFieldIndex = index;
                                      });
                                    },
                                    isSelected: currentFieldIndex == index
                                        ? true
                                        : false,
                                    title: filterData.data?[index].name ?? "")),
                          )),
                      SizedBox(
                        width: width * 0.7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 1))),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    controller: searchController,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        filterData = assign();
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        filterData = assign();
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        active = false;
                                      } else {
                                        active = true;
                                      }

                                      setState(
                                        () {
                                          filterData = assign();
                                        },
                                      );
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20.0, top: 10, bottom: 10),
                                          child: Icon(Icons.search),
                                        ),
                                        hintText: searchFilter,
                                        hintStyle: TextStyle(fontSize: 14)),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  _customButton(
                                    context: context,
                                    buttonText: resetSelection,
                                    fontSize: 12,
                                    onTap: () {
                                      searchController.clear();
                                      setState(() {
                                        filterData = assign();
                                        active = false;
                                      });
                                      widget.getCompaniesData;
                                    },
                                    textColor: theme.floatingActionButtonTheme
                                        .foregroundColor,
                                    buttonColor: active
                                        ? theme.indicatorColor
                                        : theme.focusColor,
                                    buttonBorderColor: active
                                        ? theme.indicatorColor
                                        : theme.focusColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ),
                                ],
                              ),
                              Column(
                                  children: List.generate(
                                      // selectionList[currentFieldIndex]
                                      //     .length,
                                      filterData.data?[currentFieldIndex]
                                              .filterData?.length ??
                                          0,
                                      (index) => _customCheckbox(
                                          context: context,
                                          title: filterData
                                                  .data?[currentFieldIndex]
                                                  .filterData?[index]
                                                  .displayName ??
                                              "",
                                          isChecked: filterData
                                                  .data?[currentFieldIndex]
                                                  .filterData?[index]
                                                  .isSelected ??
                                              false,
                                          onChanged: (isChecked) {
                                            if (isChecked == true) {
                                              setState(
                                                () {
                                                  active = true;
                                                },
                                              );
                                            }

                                            filterData.data?[currentFieldIndex]
                                                .filterData
                                                ?.forEach((element) =>
                                                    element.isSelected = false);

                                            setState(() {
                                              filterData
                                                  .data?[currentFieldIndex]
                                                  .filterData?[index]
                                                  .isSelected = isChecked!;
                                            });

                                            setState(() {
                                              active = containsTrue(filterData
                                                          .data?[0]
                                                          .filterData ??
                                                      [FilterData()]) ||
                                                  containsTrue(filterData
                                                          .data?[1]
                                                          .filterData ??
                                                      [FilterData()]);
                                            });
                                            searchController.clear();
                                          }))),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _customButton(
                          width: MediaQuery.of(context).size.width / 3,
                          context: context,
                          textColor:
                              theme.floatingActionButtonTheme.foregroundColor,
                          buttonText: cancel,
                          buttonColor: theme.focusColor,
                          buttonBorderColor: Theme.of(context).shadowColor,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        _customButton(
                          buttonColor: theme.indicatorColor,
                          textColor:
                              theme.floatingActionButtonTheme.foregroundColor,
                          width: MediaQuery.of(context).size.width / 3,
                          context: context,
                          buttonText: apply,
                          onTap: () {
                            widget.getCompaniesData(
                              primaryKeyData: extractFilterData(
                                  filterData.data?[0].filterData ??
                                      [FilterData()]),
                              secondaryLKey: extractFilterData(
                                  filterData.data?[1].filterData ??
                                      [FilterData()]),
                              searchTextData: searchController.text,
                            );

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        })));
  }
}

Widget _selectedContainers({
  required String title,
  bool? isSelected,
  required BuildContext context,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
        left: const BorderSide(color: Colors.grey),
      
        bottom: isSelected == null
            ? const BorderSide(color: Colors.grey)
            : isSelected
                ? BorderSide(
                    color: Theme.of(context).primaryColorDark, width: 6)
                : BorderSide(color: Theme.of(context).shadowColor),
      )),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(child: Text(title)),
    ),
  );
}

Widget _customCheckbox(
    {required String title,
    required bool isChecked,
    required BuildContext context,
    required void Function(bool?)? onChanged}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Checkbox(
              activeColor: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: isChecked,
              onChanged: onChanged),
          Text(title),
        ],
      ),
      Container(
        width: double.infinity,
        color: Theme.of(context).shadowColor,
        height: 0.5,
      ),
    ],
  );
}

Widget _customButton(
    {required BuildContext context,
    required String buttonText,
    Color? buttonColor,
    EdgeInsetsGeometry? padding,
    Color? buttonBorderColor,
    void Function()? onTap,
    double? width,
    double? fontSize,
    Color? textColor}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
   
      color: buttonColor ?? Theme.of(context).shadowColor,
    ),
    width: width,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Center(
            child: Padding(
          padding: padding ?? const EdgeInsets.all(10),
          child: Text(
            buttonText,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600),
          ),
        )),
      ),
    ),
  );
}
