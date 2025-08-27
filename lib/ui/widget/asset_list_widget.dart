import 'package:crypto_app/logic/models/crypto_asset.dart';
import 'package:crypto_app/ui/widget/asset_list_item_widget.dart';
import 'package:flutter/material.dart';

class AssetListWidget extends StatelessWidget {
  const AssetListWidget({
    super.key,
    required this.cryptoList,
    this.isLoadingMore = false,
    this.scrollController,
  });

  final List<CryptoAsset> cryptoList;
  final bool isLoadingMore;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: cryptoList.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoadingMore && index == cryptoList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final asset = cryptoList[index];
        return AssetListItemWidget(
          assetId: asset.id,
          assetName: asset.name,
          assetSymbol: asset.symbol,
          assetPrice: asset.price,
          assetColor: asset.color,
        );
      },
    );
  }
}
