import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../features/edit_profile/view/edit_profile_page.dart';
import '../features/home/home.dart';
import '../features/profile_overview/profile_overview.dart';
import '../features/receipt/receipt.dart';
import 'classes/classes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: ':id/:index',
          builder: (context, state) {
            final id = state.params['id'];
            final index = state.params['index'];
            return ProfileOverviewPage(
              id: id!,
              index: int.parse(index!),
            );
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                return EditProfilePage(
                  profile: state.extra as Profile,
                );
              },
            ),
            GoRoute(
              path: 'receipt/:paymentId',
              builder: (context, state) {
                return ReceiptPage(
                    receiptDetails: state.extra as ReceiptDetails);
                // return BlocProvider(
                //   create: (_) =>
                //       BlocProvider.of<ProfileDetailsBloc>(contexts),
                //   child: ReceiptPage(
                //     payment: state.extra as Payment,
                //   ),
                // );
              },
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        state.error.toString(),
      ),
    ),
  ),
  debugLogDiagnostics: true,
);
