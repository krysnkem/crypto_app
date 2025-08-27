import 'package:crypto_app/logic/models/crypto_asset.dart';
import 'package:equatable/equatable.dart';

sealed class CryptoListState extends Equatable {
  const CryptoListState({this.cryptoList = const []});
  final List<CryptoAsset> cryptoList;

  @override
  List<Object?> get props => [cryptoList];
}

class CryptoListInitial extends CryptoListState {
  const CryptoListInitial();
}

class CryptoListLoading extends CryptoListState {
  const CryptoListLoading();
}

class CryptoListLoaded extends CryptoListState {
  const CryptoListLoaded({required super.cryptoList});
  @override
  List<Object?> get props => [cryptoList];
}

class CryptoListLoadingMore extends CryptoListState {
  const CryptoListLoadingMore({required super.cryptoList});
  @override
  List<Object?> get props => [cryptoList];
}

class CryptoListError extends CryptoListState {
  final String message;
  const CryptoListError({required this.message, super.cryptoList});

  @override
  List<Object?> get props => [message, cryptoList];
}
