import '../models/voucher_model.dart';
import '../models/redemption_model.dart';

abstract class VoucherRepository {
  Future<List<VoucherModel>> getAvailableVouchers();
  Future<VoucherModel> getVoucherById(String voucherId);
  Future<RedemptionModel> redeemVoucher(String userId, String voucherId);
  Future<List<RedemptionModel>> getUserRedemptions(String userId);
  Future<bool> canUserRedeem(String userId, String voucherId);
}

