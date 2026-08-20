import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/view/screens/auth_screen.dart';
import '../../view_model/onboarding_bloc.dart';
import '../../view_model/onboarding_event.dart';
import '../../view_model/onboarding_state.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    context.read<OnboardingBloc>().add(
          OnboardingStartedEvent(),
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _isProgrammaticChange = true;

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OnboardingLoading ||
                state is OnboardingInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is OnboardingError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is OnboardingLoaded) {
              return Column(
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                        right: 20,
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                                OnboardingSkipPressed(),
                              );
                        },
                        child: const Text(
                          'تخطي',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF825429),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Onboarding Pages
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.pages.length,
                      onPageChanged: (index) {
                        if (_isProgrammaticChange) {
                          _isProgrammaticChange = false;
                          return;
                        }

                        if (index > state.currentPage) {
                          context.read<OnboardingBloc>().add(
                                OnboardingNextPressed(),
                              );
                        } else if (index < state.currentPage) {
                          context.read<OnboardingBloc>().add(
                                OnboardingPreviousPressed(),
                              );
                        }
                      },
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          page: state.pages[index],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.pages.length,
                      (index) {
                        final isSelected =
                            index == state.currentPage;

                        return AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 250,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10),
                            color: isSelected
                                ? const Color(0xFF825429)
                                : Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        // Previous Button
                        if (state.currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context
                                    .read<OnboardingBloc>()
                                    .add(
                                      OnboardingPreviousPressed(),
                                    );

                                _goToPage(
                                  state.currentPage - 1,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  52,
                                ),
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFFD0CCC8),
                                  width: 1.2,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'السابق',
                                style: TextStyle(
                                  color: Color(0xFF8C8884),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        else
                          const Spacer(),

                        const SizedBox(width: 16),

                        // Next / Get Started Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final isLastPage =
                                  state.currentPage ==
                                      state.pages.length - 1;

                              if (isLastPage) {
                                context
                                    .read<OnboardingBloc>()
                                    .add(
                                      OnboardingStartedPressed(),
                                    );
                              } else {
                                context
                                    .read<OnboardingBloc>()
                                    .add(
                                      OnboardingNextPressed(),
                                    );

                                _goToPage(
                                  state.currentPage + 1,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                52,
                              ),
                              backgroundColor:
                                  const Color(0xFF252A32),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              state.currentPage ==
                                      state.pages.length - 1
                                  ? 'ابدأ الآن'
                                  : 'التالي',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}