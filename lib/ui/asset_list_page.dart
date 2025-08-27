import 'package:crypto_app/core/util/ui_constants.dart';
import 'package:crypto_app/logic/models/crypto_asset.dart';
import 'package:crypto_app/logic/notifiers/crypto_list_cubit.dart';
import 'package:crypto_app/logic/states/crypto_list_state.dart';
import 'package:crypto_app/ui/widget/asset_list_widget.dart';
import 'package:crypto_app/ui/widget/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetListPage extends StatefulWidget {
  const AssetListPage({super.key});

  @override
  State<AssetListPage> createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_setupScrollLoadMoreLogic);
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
      context.read<CryptoListCubit>().loadMoreAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.pageHorizontalPadding,
        ),
        child: SafeArea(
          child: BlocBuilder<CryptoListCubit, CryptoListState>(
            builder: (context, state) {
              final notifier = context.read<CryptoListCubit>();
              return switch (state) {
                CryptoListLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                CryptoListInitial() => const Center(
                  child: CircularProgressIndicator(),
                ),
                CryptoListLoaded(:final cryptoList) =>
                  RefreshableAssetListWidget(
                    notifier: notifier,
                    cryptoList: cryptoList,
                    scrollController: _scrollController,
                  ),
                CryptoListLoadingMore(:final cryptoList) =>
                  RefreshableAssetListWidget(
                    notifier: notifier,
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
                          notifier: notifier,
                          cryptoList: cryptoList,
                          scrollController: _scrollController,
                        ),
                      ),
                    ErrorStateWidget(
                      message: message,
                      onRetry: () {
                        cryptoList.isNotEmpty
                            ? notifier.loadMoreAssets()
                            : notifier.loadAssets();
                      },
                    ),
                  ],
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class RefreshableAssetListWidget extends StatelessWidget {
  const RefreshableAssetListWidget({
    super.key,
    required CryptoListCubit notifier,
    required this.cryptoList,
    required ScrollController scrollController,
    this.isLoadingMore = false,
  }) : _notifier = notifier,
       _scrollController = scrollController;

  final CryptoListCubit _notifier;
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
