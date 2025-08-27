import 'package:crypto_app/core/util/text_styles.dart';
import 'package:crypto_app/core/util/ui_constants.dart';
import 'package:flutter/material.dart';

class AssetListItemWidget extends StatelessWidget {
  const AssetListItemWidget({
    super.key,
    required this.assetId,
    required this.assetName,
    required this.assetSymbol,
    required this.assetPrice,
    required this.assetColor,
  });
  final String assetId;
  final String assetName;
  final String assetSymbol;
  final String assetPrice;
  final Color assetColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.assetItemPadding,
      ),
      child: Row(
        children: [
          Container(
            width: UIConstants.assetIconSize,
            height: UIConstants.assetIconSize,
            decoration: BoxDecoration(
              color: assetColor,
              borderRadius: BorderRadius.circular(
                UIConstants.assetIconBorderRadius,
              ),
            ),
          ),
          const SizedBox(width: UIConstants.assetItemSpacing),
          Expanded(
            child: Text(
              '$assetName ($assetSymbol)', // Added space for better readability
              style: sfProText17600TextBlack,
            ),
          ),
          Text(
            '\$$assetPrice', // Added dollar sign prefix
            style: sfProText17600TextBlack,
          ),
        ],
      ),
    );
  }
}
