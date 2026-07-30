import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //   width: 28,
        //   height: 28,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(7),
        //     border: Border.all(color: AppColors.accent, width: 1.4),
        //   ),
        //   clipBehavior: Clip.antiAlias,
        //   child: Image.network(
        //     'https://lightsignal.app/ls-logo.png',
        //     width: 26,
        //     height: 26,
        //     fit: BoxFit.contain,
        //     errorBuilder: (context, error, stackTrace) => const Text(
        //       'LS',
        //       style: TextStyle(
        //         color: AppColors.accent,
        //         fontSize: 11,
        //         fontWeight: FontWeight.w800,
        //       ),
        //     ),
        //     loadingBuilder: (context, child, progress) {
        //       if (progress == null) return child;
        //       return const Text(
        //         'LS',
        //         style: TextStyle(
        //           color: AppColors.accent,
        //           fontSize: 11,
        //           fontWeight: FontWeight.w800,
        //         ),
        //       );
        //     },
        //   ),
        // ),
     
       Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: AppColors.accent, width: 1.4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/ls_logo.png',
            width: 26,
            height: 26,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 8),
        const Text('LightSignal', style: AppTextStyles.logo),
      ],
    );
  }
}
