import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const POINTS_PER_VIDEO = 10;
const POINTS_PER_LIKE = 1;
const POINTS_PER_FOLLOWER = 5;

// Resgate de voucher com verificação atômica
export const redeemVoucher = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Usuário não autenticado'
    );
  }

  const { userId, voucherId } = data;

  if (userId !== context.auth.uid) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Usuário não autorizado'
    );
  }

  return await db.runTransaction(async (transaction) => {
    // Buscar dados do usuário
    const userRef = db.collection('users').doc(userId);
    const userDoc = await transaction.get(userRef);
    
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Usuário não encontrado');
    }

    const userData = userDoc.data()!;
    const userScore = userData.score || 0;

    // Buscar dados do voucher
    const voucherRef = db.collection('vouchers').doc(voucherId);
    const voucherDoc = await transaction.get(voucherRef);
    
    if (!voucherDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Voucher não encontrado');
    }

    const voucherData = voucherDoc.data()!;
    const pointsCost = voucherData.pointsCost || 0;
    const isActive = voucherData.isActive !== false;
    const stock = voucherData.stock || 0;

    // Verificações
    if (!isActive) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Voucher não está ativo'
      );
    }

    if (userScore < pointsCost) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Pontos insuficientes'
      );
    }

    if (stock > 0) {
      // Verificar se há estoque
      const currentStock = voucherData.stock;
      if (currentStock <= 0) {
        throw new functions.https.HttpsError(
          'failed-precondition',
          'Voucher esgotado'
        );
      }
      transaction.update(voucherRef, { stock: admin.firestore.FieldValue.increment(-1) });
    }

    // Verificar se já resgatou
    const redemptionQuery = await transaction.get(
      db.collection('redemptions')
        .where('userId', '==', userId)
        .where('voucherId', '==', voucherId)
        .limit(1)
    );

    if (!redemptionQuery.empty) {
      throw new functions.https.HttpsError(
        'already-exists',
        'Voucher já foi resgatado'
      );
    }

    // Criar resgate
    const redemptionId = db.collection('redemptions').doc().id;
    const redemptionRef = db.collection('redemptions').doc(redemptionId);
    
    transaction.set(redemptionRef, {
      userId,
      voucherId,
      pointsSpent: pointsCost,
      redeemedAt: admin.firestore.FieldValue.serverTimestamp(),
      isUsed: false,
    });

    // Deduzir pontos do usuário
    transaction.update(userRef, {
      score: admin.firestore.FieldValue.increment(-pointsCost),
    });

    return {
      id: redemptionId,
      userId,
      voucherId,
      pointsSpent: pointsCost,
      redeemedAt: new Date().toISOString(),
      isUsed: false,
    };
  });
});

// Incrementar pontos quando vídeo é criado
export const onVideoCreated = functions.firestore
  .document('videos/{videoId}')
  .onCreate(async (snap, context) => {
    const videoData = snap.data();
    const ownerId = videoData.ownerId;

    const userRef = db.collection('users').doc(ownerId);
    await userRef.update({
      score: admin.firestore.FieldValue.increment(POINTS_PER_VIDEO),
      videosCount: admin.firestore.FieldValue.increment(1),
    });

    return null;
  });

// Incrementar pontos quando recebe like
export const onLikeCreated = functions.firestore
  .document('videos/{videoId}/likes/{likeId}')
  .onCreate(async (snap, context) => {
    const likeData = snap.data();
    const userId = likeData.userId;

    if (userId) {
      const userRef = db.collection('users').doc(userId);
      await userRef.update({
        score: admin.firestore.FieldValue.increment(POINTS_PER_LIKE),
      });
    }

    return null;
  });

// Incrementar pontos quando recebe seguidor
export const onFollowerCreated = functions.firestore
  .document('users/{userId}/followers/{followerId}')
  .onCreate(async (snap, context) => {
    const userId = context.params.userId;

    const userRef = db.collection('users').doc(userId);
    await userRef.update({
      score: admin.firestore.FieldValue.increment(POINTS_PER_FOLLOWER),
    });

    return null;
  });

// Enviar notificação de boas-vindas quando o usuário faz login
export const onUserLogin = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Verificar se o fcmToken foi atualizado (indicando login)
    const beforeToken = beforeData.fcmToken;
    const afterToken = afterData.fcmToken;

    // Se o token foi atualizado e não existia antes, é um novo login
    if (afterToken && afterToken !== beforeToken) {
      const userDisplayName = afterData.displayName || afterData.username || 'Usuário';
      
      const message = {
        notification: {
          title: 'Bem-vindo de volta! 👋',
          body: `Olá ${userDisplayName}, é bom ter você aqui novamente!`,
        },
        data: {
          type: 'login',
          userId: userId,
        },
        token: afterToken,
      };

      try {
        await admin.messaging().send(message);
        console.log(`Notificação de login enviada para ${userId}`);
      } catch (error) {
        console.error(`Erro ao enviar notificação de login: ${error}`);
      }
    }

    return null;
  });

