import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../../domain/models/voucher_model.dart';
import '../../domain/models/redemption_model.dart';
import '../../core/constants/firestore_collections.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  VoucherRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions;

  @override
  Future<List<VoucherModel>> getAvailableVouchers() async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.vouchers)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => VoucherModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<VoucherModel> getVoucherById(String voucherId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.vouchers)
        .doc(voucherId)
        .get();

    if (!doc.exists) {
      throw Exception('Voucher não encontrado');
    }

    return VoucherModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<RedemptionModel> redeemVoucher(String userId, String voucherId) async {
    // Chamar Cloud Function para resgate atômico
    final callable = _functions.httpsCallable('redeemVoucher');
    final result = await callable.call({
      'userId': userId,
      'voucherId': voucherId,
    });

    final redemptionData = result.data as Map<String, dynamic>;
    return RedemptionModel.fromJson(redemptionData);
  }

  @override
  Future<List<RedemptionModel>> getUserRedemptions(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.redemptions)
        .where('userId', isEqualTo: userId)
        .orderBy('redeemedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RedemptionModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<bool> canUserRedeem(String userId, String voucherId) async {
    final userDoc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();
    final voucherDoc = await _firestore
        .collection(FirestoreCollections.vouchers)
        .doc(voucherId)
        .get();

    if (!userDoc.exists || !voucherDoc.exists) return false;

    final userData = userDoc.data()!;
    final voucherData = voucherDoc.data()!;

    final userScore = userData['score'] as int? ?? 0;
    final voucherCost = voucherData['pointsCost'] as int? ?? 0;
    final isActive = voucherData['isActive'] as bool? ?? false;

    if (!isActive || userScore < voucherCost) return false;

    // Verificar se já resgatou
    final redemptionSnapshot = await _firestore
        .collection(FirestoreCollections.redemptions)
        .where('userId', isEqualTo: userId)
        .where('voucherId', isEqualTo: voucherId)
        .get();

    return redemptionSnapshot.docs.isEmpty;
  }
}

