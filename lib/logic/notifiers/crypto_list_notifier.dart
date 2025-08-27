import 'package:crypto_app/core/secrets/api_key.dart';
import 'package:crypto_app/core/util/color_generator.dart';
import 'package:crypto_app/core/util/string_extenstion.dart';
import 'package:crypto_app/data/api/coincap_api_models.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/coin_cap_repository.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/i_coin_cap_repository.dart';
import 'package:crypto_app/data/repository/result.dart';
import 'package:crypto_app/data/setup_coin_cap_api_client.dart';
import 'package:crypto_app/logic/models/crypto_asset.dart';
import 'package:crypto_app/logic/states/crypto_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CryptoListNotifier extends ValueNotifier<CryptoListState> {
  CryptoListNotifier({required ICoinCapRepository coinCapRepository})
    : _coinCapRepository = coinCapRepository,
      super(CryptoListInitial());

  final ICoinCapRepository _coinCapRepository;

  static int limit = 15;
  int valueIndex = 0;

  int get offset => valueIndex * limit;

  Future<void> loadAssets() async {
    value = CryptoListLoading();
    final result = await _coinCapRepository.getAssets(
      AssetsQuery(limit: limit, offset: 0),
    );
    switch (result) {
      case Success<AssetsListResponse>(:final data):
        if (data == null || data.data?.isEmpty == true) {
          value = CryptoListError(message: 'No assets found.');
          return;
        }
        final List<CryptoAsset> cryptoAssets = [];
        for (final asset in data.data!) {
          Color color = ColorGenerator.generateColor();
          final existingEntry = cryptoAssets.indexWhere(
            (cryptoAsset) => cryptoAsset.id == asset.id,
          );
          if (existingEntry != -1) {
            color = cryptoAssets[existingEntry].color;
          }
          cryptoAssets.add(
            CryptoAsset(
              color: color,
              id: asset.id ?? '',
              name: asset.name ?? '',
              symbol: asset.symbol ?? '',
              price: asset.priceusd.money,
            ),
          );
        }

        valueIndex = 1;
        value = CryptoListLoaded(cryptoList: cryptoAssets);
        break;
      case Failure(:final message):
        value = CryptoListError(message: message, cryptoList: value.cryptoList);
        break;
    }
  }

  void loadMoreAssets() async {
    if (value is CryptoListLoading || value is CryptoListLoadingMore) return;

    final currentState = value;
    if (currentState is CryptoListLoaded ||
        (currentState is CryptoListError &&
            currentState.cryptoList.isNotEmpty)) {
      value = CryptoListLoadingMore(cryptoList: currentState.cryptoList);
      final result = await _coinCapRepository.getAssets(
        AssetsQuery(limit: limit, offset: offset),
      );
      switch (result) {
        case Success<AssetsListResponse>(:final data):
          if (data == null || data.data?.isEmpty == true) {
            value = CryptoListLoaded(cryptoList: currentState.cryptoList);
            return;
          }
          final List<CryptoAsset> updatedCryptoAssets = List.from(
            currentState.cryptoList,
          );
          for (final asset in data.data!) {
            Color color = ColorGenerator.generateColor();
            final existingEntry = updatedCryptoAssets.indexWhere(
              (cryptoAsset) => cryptoAsset.id == asset.id,
            );
            if (existingEntry != -1) {
              color = updatedCryptoAssets[existingEntry].color;
            }
            updatedCryptoAssets.add(
              CryptoAsset(
                color: color,
                id: asset.id ?? '',
                name: asset.name ?? '',
                symbol: asset.symbol ?? '',
                price: asset.priceusd.money,
              ),
            );
          }
          valueIndex++;
          value = CryptoListLoaded(cryptoList: updatedCryptoAssets);
          break;
        case Failure(:final message):
          value = CryptoListError(
            message: message,
            cryptoList: currentState.cryptoList,
          );
          break;
      }
    }
  }
}

final cryptoListValuNotifier = CryptoListNotifier(
  coinCapRepository: CoinCapRepository(setUpCoinCapApiClient(COINCAP_API_KEY)),
);
