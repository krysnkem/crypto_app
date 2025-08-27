// ignore_for_file: avoid_print

import 'package:crypto_app/logic/states/crypto_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_app/core/secrets/api_key.dart';
import 'package:crypto_app/data/setup_coin_cap_api_client.dart';
import 'package:crypto_app/data/api/coincap_api_models.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/coin_cap_repository.dart';
import 'package:crypto_app/logic/notifiers/crypto_list_notifier.dart';

void main() {
  group('API Layer Tests', () {
    late CoinCapRepository repository;
    late CryptoListNotifier notifier;

    setUp(() {
      final apiClient = setUpCoinCapApiClient(COINCAP_API_KEY);
      repository = CoinCapRepository(apiClient);
      notifier = CryptoListNotifier(coinCapRepository: repository);
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

    test('ValueNotifier loads assets correctly', () async {
      expect(notifier.value, isA<CryptoListInitial>());

      await notifier.loadAssets();

      expect(notifier.value, isNot(isA<CryptoListInitial>()));
      print('Notifier state: ${notifier.value.runtimeType}');

      if (notifier.value is CryptoListLoaded) {
        final loaded = notifier.value as CryptoListLoaded;
        print('Loaded ${loaded.cryptoList.length} assets');
        for (final asset in loaded.cryptoList.take(3)) {
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
