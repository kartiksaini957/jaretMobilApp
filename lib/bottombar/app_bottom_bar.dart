import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One icon slot on [AppBottomBar]: an icon plus an optional badge count.
// class BottomBarItem {
//   const BottomBarItem({required this.icon, this.badgeCount, this.image,}): assert(
//           icon != null || image != null,
//           'Either icon or image must be provided',
//         );

//   final IconData icon;
//   final String? image;
//   final int? badgeCount;
// }
class BottomBarItem {
  const BottomBarItem({this.icon, this.image, this.badgeCount})
    : assert(
        icon != null || image != null,
        'Either icon or image must be provided',
      );

  final IconData? icon;
  final String? image; // asset image path
  final int? badgeCount;
}

/// Pill-shaped frosted-glass bottom navigation bar with a selected-state
/// highlight and small count badges per icon.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<BottomBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassDark,
            borderRadius: BorderRadius.circular(32),
            // border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              return _BottomBarButton(
                item: items[index],
                isSelected: index == selectedIndex,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  const _BottomBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.white.withValues(alpha: 0.34),
                          AppColors.white.withValues(alpha: 0.08),
                        ],
                      )
                    : null,
                border: isSelected
                    ? Border.all(color: AppColors.glassBorder)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: item.image != null
                  ? Image.asset(
                      item.image!,
                      width: 30,
                      height: 30,
                      color: AppColors.white, // agar PNG/SVG monochrome ho
                    )
                  : Icon(item.icon, size: 20, color: AppColors.white),
              // child:
              //  Icon(item.icon, size: 20, color: AppColors.white),
            ),
            if (item.badgeCount != null)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassDark, width: 1.5),
                  ),
                  child: Text(
                    '${item.badgeCount}',
                    style: const TextStyle(
                      color: AppColors.baseDeep,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
