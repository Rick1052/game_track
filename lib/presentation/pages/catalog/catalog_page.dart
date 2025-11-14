import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/voucher_providers.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/voucher_model.dart';
import '../../widgets/atoms/primary_button.dart';
import 'package:game_track/l10n/app_localizations.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vouchersAsync = ref.watch(vouchersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalog),
      ),
      body: vouchersAsync.when(
        data: (vouchers) {
          if (vouchers.isEmpty) {
            return Center(
              child: Text(l10n.noResults),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              return _VoucherCard(voucher: voucher);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erro: $error'),
        ),
      ),
    );
  }
}

class _VoucherCard extends ConsumerWidget {
  final VoucherModel voucher;

  const _VoucherCard({required this.voucher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final canRedeemAsync = ref.watch(canRedeemProvider(
      RedeemParams(
        userId: ref.watch(authControllerProvider).value?.id ?? '',
        voucherId: voucher.id,
      ),
    ));

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              voucher.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  voucher.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pointsCost(voucher.pointsCost),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                canRedeemAsync.when(
                  data: (canRedeem) => PrimaryButton(
                    text: l10n.redeem,
                    onPressed: canRedeem
                        ? () async {
                            try {
                              final userId = ref.read(authControllerProvider).value?.id ?? '';
                              await ref.read(voucherRepositoryProvider).redeemVoucher(
                                    userId,
                                    voucher.id,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.redemptionSuccess),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro: $e'),
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    height: 36,
                  ),
                  loading: () => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

