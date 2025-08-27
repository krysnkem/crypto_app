// ignore_for_file: avoid_print

import 'package:crypto_app/logic/states/crypto_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_app/core/secrets/api_key.dart';
import 'package:crypto_app/data/setup_coin_cap_api_client.dart';
import 'package:crypto_app/data/api/coincap_api_models.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/coin_cap_repository.dart';
import 'package:crypto_app/logic/notifiers/crypto_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('API Layer Tests', () {
    late CoinCapRepository repository;

    setUp(() {
      final apiClient = setUpCoinCapApiClient(COINCAP_API_KEY);
      repository = CoinCapRepository(apiClient);
    });

    test('API client setup with interceptors', () {
      final client = setUpCoinCapApiClient(COINCAP_API_KEY);
      expect(client, isNotNull);
    });

    test('Repository can fetch assets', () async {
      final result = await repository.getAssets(
        const AssetsQuery(limit: 5, offset: 0),
      );

      expect(result, isNotNull);
      print('API Result: $result');
    });

    test('Riverpod Notifier loads assets correctly', () async {
      // Create a ProviderContainer for testing
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Get the notifier from the container
      final notifier = container.read(cryptoListNotifierProvider.notifier);
      final initialState = container.read(cryptoListNotifierProvider);

      expect(initialState, isA<CryptoListInitial>());

      await notifier.loadAssets();

      final finalState = container.read(cryptoListNotifierProvider);
      expect(finalState, isNot(isA<CryptoListInitial>()));
      print('Notifier state: ${finalState.runtimeType}');

      if (finalState is CryptoListLoaded) {
        print('Loaded ${finalState.cryptoList.length} assets');
        for (final asset in finalState.cryptoList.take(3)) {
          print('Asset: ${asset.name} (${asset.symbol}) - \$${asset.price}');
        }
      }
    });

    test('API key interceptor works', () {
      final client = setUpCoinCapApiClient('test-key');
      expect(client, isNotNull);
    });
  });
}
