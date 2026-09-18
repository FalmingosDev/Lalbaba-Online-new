import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../account/presentation/widgets/app_string.dart';

class AddressTypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AddressTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static List<_AddressTypeItem> _items = [
    _AddressTypeItem(value: AppStrings.home, icon: Icons.home_outlined),
    _AddressTypeItem(value: AppStrings.office, icon: Icons.work_outline),
    _AddressTypeItem(value: AppStrings.other, icon: Icons.location_on_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items.map((item) {
        final isSelected = value == item.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: item.value == 'Other' ? 0 : 8.w),
            child: InkWell(
              onTap: () => onChanged(item.value),
              borderRadius: BorderRadius.circular(14.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Icon(
                    //   item.icon,
                    //   size: 21.sp,
                    //   color: isSelected
                    //       ? AppColors.primary
                    //       : Colors.grey.shade600,
                    // ),
                    // SizedBox(height: 5.h),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AddressTypeItem {
  final String value;
  final IconData icon;

  const _AddressTypeItem({required this.value, required this.icon});
}
