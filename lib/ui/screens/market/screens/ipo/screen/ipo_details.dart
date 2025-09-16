import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IpoDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ipoDataList;
  const IpoDetailsScreen({super.key, required this.ipoDataList});

  @override
  State<IpoDetailsScreen> createState() => _IpoDetailsScreenState();
}

class _IpoDetailsScreenState extends State<IpoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: _buildIPoContainer(theme),
    );
  }

//Widget for Ipo Container
  Widget _buildIPoContainer(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.ipoDataList.length,
      itemBuilder: (context, index) {
        final ipo = widget.ipoDataList[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.shadowColor,
                  width: 1,
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name and type badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ipo['companyName'],
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.primaryColorDark,
                            fontSize: 12.sp,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.indicatorColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ipo['companyType'],
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.primaryColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Dates
                    Text(
                      '${ipo['openClosedDates']}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.focusColor,
                        fontSize: 8.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Min investment | Issue size | GMP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Min Investment',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor,
                                fontSize: 8.sp,
                              ),
                            ),
                            Text(
                              ipo['minInvestment'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Issue Size',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor,
                                fontSize: 8.sp,
                              ),
                            ),
                            Text(
                              ipo['issueSize'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'GMP',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor,
                                fontSize: 8.sp,
                              ),
                            ),
                            Text(
                              ipo['gmp'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: ipo['gmp'].toString().startsWith('+')
                                    ? theme.secondaryHeaderColor
                                    : theme.disabledColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
