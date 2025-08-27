import 'package:crypto_app/core/util/ui_constants.dart';
import 'package:crypto_app/logic/models/crypto_asset.dart';
import 'package:crypto_app/logic/notifiers/crypto_list_notifier.dart';
import 'package:crypto_app/logic/states/crypto_list_state.dart';
import 'package:crypto_app/ui/widget/asset_list_widget.dart';
import 'package:crypto_app/ui/widget/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetListPage extends ConsumerStatefulWidget {
  const AssetListPage({super.key});

  @override
  ConsumerState<AssetListPage> createState() => _AssetListPageState();
}

class _AssetListPageState extends ConsumerState<AssetListPage> {
  late CryptoListNotifier _notifier;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(cryptoListNotifierProvider.notifier);
    _scrollController.addListener(_setupScrollLoadMoreLogic);
    //Due to changes from ValueNotifier to Riverpod's Notifier, we need to call loadAssets here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.loadAssets();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_setupScrollLoadMoreLogic);
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollLoadMoreLogic() {
    if (_scrollController.position.pixels != 0 &&
        _scrollController.position.atEdge) {
      _notifier.loadMoreAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cryptoListNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.pageHorizontalPadding,
        ),
        child: SafeArea(
          child: switch (state) {
            CryptoListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CryptoListInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            CryptoListLoaded(:final cryptoList) => RefreshableAssetListWidget(
              notifier: _notifier,
              cryptoList: cryptoList,
              scrollController: _scrollController,
            ),
            CryptoListLoadingMore(:final cryptoList) =>
              RefreshableAssetListWidget(
                notifier: _notifier,
                cryptoList: cryptoList,
                scrollController: _scrollController,
                isLoadingMore: true,
              ),
            CryptoListError(:final message, :final cryptoList) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (cryptoList.isNotEmpty)
                  Expanded(
                    child: RefreshableAssetListWidget(
                      notifier: _notifier,
                      cryptoList: cryptoList,
                      scrollController: _scrollController,
                    ),
                  ),
                ErrorStateWidget(
                  message: message,
                  onRetry: () {
                    cryptoList.isNotEmpty
                        ? _notifier.loadMoreAssets()
                        : _notifier.loadAssets();
                  },
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}

class RefreshableAssetListWidget extends StatelessWidget {
  const RefreshableAssetListWidget({
    super.key,
    required CryptoListNotifier notifier,
    required this.cryptoList,
    required ScrollController scrollController,
    this.isLoadingMore = false,
  }) : _notifier = notifier,
       _scrollController = scrollController;

  final CryptoListNotifier _notifier;
  final List<CryptoAsset> cryptoList;
  final ScrollController _scrollController;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await _notifier.loadAssets();
      },
      child: AssetListWidget(
        cryptoList: cryptoList,
        scrollController: _scrollController,
        isLoadingMore: isLoadingMore,
      ),
    );
  }
}
