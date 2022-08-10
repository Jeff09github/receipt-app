import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_app/src/shared/providers/firebase/firestore_database.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';
import 'package:receipt_app/src/shared/router.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue, brightness: Brightness.light);

  final firestoreDatabase = FirestoreDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) =>
              FirestoreDatabaseRepository(firestoreDatabase: firestoreDatabase),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'PPPOE RECEIPT',
        theme: ThemeData.light().copyWith(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: colorScheme.background,
          appBarTheme: AppBarTheme(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onSurface,
              elevation: 0),
          iconTheme: IconThemeData(color: colorScheme.primary),
          listTileTheme: ListTileThemeData(
            tileColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(colorScheme.onPrimary),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          useMaterial3: true,
        ),
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
        routerDelegate: appRouter.routerDelegate,
      ),
    );
  }
}
