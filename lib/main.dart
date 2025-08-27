import 'package:crypto_app/core/routing/routing.dart';
import 'package:crypto_app/core/secrets/api_key.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/coin_cap_repository.dart';
import 'package:crypto_app/data/setup_coin_cap_api_client.dart';
import 'package:crypto_app/logic/notifiers/crypto_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CryptoListCubit(
            coinCapRepository: CoinCapRepository(
              setUpCoinCapApiClient(COINCAP_API_KEY),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Archonit Crypto App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: RoutePath.splash,
        onGenerateRoute: Routing.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
