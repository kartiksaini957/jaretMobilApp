import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/customElevatedbutton.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import 'onboarding_providers.dart';
import 'widgets/it_finds_things_pane.dart';
import 'widgets/promise_pane.dart';
import 'widgets/show_dont_tell_pane.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  void _goToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingPageProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Align(alignment: Alignment.centerLeft, child: AppLogo()),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      ref.read(onboardingPageProvider.notifier).state = index,
                  children: const [
                    _PaneBottom(child: PromisePane()),
                    _PaneBottom(child: ShowDontTellPane()),
                    _PaneScroll(child: ItFindsThingsPane()),
                  ],
                ),
              ),
              _DotsIndicator(
                count: onboardingPageCount,
                activeIndex: currentPage,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Column(
                  children: [
                    PrimaryButton(
                      label: 'Start your free trial',
                      onPressed: _goToSignUp,
                    ),
                    LinkButton(
                      label: 'I already have an account',
                      onPressed: _goToLogin,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaneBottom extends StatelessWidget {
  const _PaneBottom({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [child],
            ),
          ),
        );
      },
    );
  }
}

class _PaneScroll extends StatelessWidget {
  const _PaneScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: child,
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.faintText,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
