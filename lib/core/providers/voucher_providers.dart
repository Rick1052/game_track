import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/voucher_model.dart';
import 'repository_providers.dart';

final vouchersProvider = FutureProvider<List<VoucherModel>>((ref) async {
  final repository = ref.watch(voucherRepositoryProvider);
  return await repository.getAvailableVouchers();
});

final canRedeemProvider = FutureProvider.family<bool, RedeemParams>((ref, params) async {
  final repository = ref.watch(voucherRepositoryProvider);
  return await repository.canUserRedeem(params.userId, params.voucherId);
});

class RedeemParams {
  final String userId;
  final String voucherId;

  RedeemParams({
    required this.userId,
    required this.voucherId,
  });
}

