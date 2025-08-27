import 'package:crypto_app/data/api/coincap_api.dart';
import 'package:crypto_app/data/repository/coin_cap_repository/i_coin_cap_repository.dart';
import 'package:crypto_app/data/repository/result.dart';
import 'package:crypto_app/data/repository/safe_call.dart';

class CoinCapRepository with SafeCall implements ICoinCapRepository {
  final CoinCapApiClient _apiClient;

  CoinCapRepository(this._apiClient);

  @override
  Future<Result<AssetsListResponse>> getAssetBySlug(String slug) =>
      safeApiCall(() => _apiClient.getAssetBySlug(slug));

  @override
  Future<Result<AssetsListResponse>> getAssets(AssetsQuery query) =>
      safeApiCall(() => _apiClient.getAssets(query));
  @override
  Future<Result<AssetsListResponse>> getExchangeByExchange(String exchange) =>
      safeApiCall(() => _apiClient.getExchangeByExchange(exchange));

  @override
  Future<Result<AssetsListResponse>> getExchanges(ExchangesQuery query) =>
      safeApiCall(() => _apiClient.getExchanges(query));

  @override
  Future<Result<AssetsListResponse>> getHistoriesBySlug(
    String slug,
    HistoryQuery query,
  ) => safeApiCall(() => _apiClient.getHistoriesBySlug(slug, query));

  @override
  Future<Result<AssetsListResponse>> getMarkets(MarketsQuery query) =>
      safeApiCall(() => _apiClient.getMarkets(query));

  @override
  Future<Result<AssetsListResponse>> getMarketsBySlug(
    String slug,
    MarketsQuery query,
  ) => safeApiCall(() => _apiClient.getMarketsBySlug(slug, query));

  @override
  Future<Result<RateResponse>> getRateBySlug(String slug) =>
      safeApiCall(() => _apiClient.getRateBySlug(slug));
  @override
  Future<Result<AssetsListResponse>> getRates(String? ids) =>
      safeApiCall(() => _apiClient.getRates(ids));
}
