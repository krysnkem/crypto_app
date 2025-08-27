import 'package:crypto_app/data/api/coincap_api_models.dart';
import 'package:crypto_app/data/repository/result.dart';

abstract class ICoinCapRepository {
  Future<Result<AssetsListResponse>> getAssetBySlug(String slug);

  Future<Result<AssetsListResponse>> getAssets(AssetsQuery query);

  Future<Result<AssetsListResponse>> getExchangeByExchange(String exchange);

  Future<Result<AssetsListResponse>> getExchanges(ExchangesQuery query);

  Future<Result<AssetsListResponse>> getHistoriesBySlug(
    String slug,
    HistoryQuery query,
  );

  Future<Result<AssetsListResponse>> getMarkets(MarketsQuery query);

  Future<Result<AssetsListResponse>> getMarketsBySlug(
    String slug,
    MarketsQuery query,
  );

  Future<Result<RateResponse>> getRateBySlug(String slug);

  Future<Result<AssetsListResponse>> getRates(String? ids);
}
