import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGridSection extends StatelessWidget {
  final String sectionTitle;
  final List<GridCardItem> items;
  final ThemeData theme;

  const CommonGridSection({
    super.key,
    required this.sectionTitle,
    required this.items,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sectionTitle,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.screen),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        color: theme.focusColor,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.blue[700]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(17.r),
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

//Model for grid items
class GridCardItem {
  final String title;
  final String subtitle;

  final IconData icon;
  final Widget screen;

  GridCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}
