import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletreasury/core/appa_theme.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuriesGets/treasuries_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuries_add_edit_delete/treasuries_add_edit_delete_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/pages/treasuries_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<TreasuriesBloc>()
                ..add(getTreasuriesWithTransactionsEvent()),
        ),
        BlocProvider(create: (_) => di.sl<TreasuriesAddEditDeleteBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: appTheme,
        home: TreasuriesPage(),
      ),
    );
  }
}
