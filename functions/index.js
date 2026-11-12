const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {logger} = require("firebase-functions");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {getAuth} = require("firebase-admin/auth");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const crypto = require("crypto");
const nodemailer = require("nodemailer");

initializeApp();

const smtpHost = defineSecret("SMTP_HOST");
const smtpPort = defineSecret("SMTP_PORT");
const smtpUser = defineSecret("SMTP_USER");
const smtpPass = defineSecret("SMTP_PASS");
const smtpFrom = defineSecret("SMTP_FROM");
const otpPepper = defineSecret("EMAIL_OTP_PEPPER");

const emailOtpSecrets = [
  smtpHost,
  smtpPort,
  smtpUser,
  smtpPass,
  smtpFrom,
  otpPepper,
];

function verificationId(email) {
  return crypto.createHash("sha256").update(email).digest("hex");
}

function codeHash(email, code) {
  return crypto
    .createHmac("sha256", otpPepper.value())
    .update(`${email}:${code}`)
    .digest("hex");
}

exports.requestRegistrationCode = onCall(
  {
    region: "asia-southeast1",
    secrets: emailOtpSecrets,
  },
  async (request) => {
    const email = String(request.data?.email || "").trim().toLowerCase();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      throw new HttpsError("invalid-argument", "Email không hợp lệ.");
    }

    try {
      await getAuth().getUserByEmail(email);
      throw new HttpsError("already-exists", "Email đã được sử dụng.");
    } catch (error) {
      if (error instanceof HttpsError) throw error;
      if (error.code !== "auth/user-not-found") throw error;
    }

    const db = getFirestore();
    const reference = db.collection("email_verifications").doc(
      verificationId(email),
    );
    const previous = await reference.get();
    const lastSentAt = previous.data()?.lastSentAt?.toMillis?.() || 0;
    if (Date.now() - lastSentAt < 60000) {
      throw new HttpsError(
        "resource-exhausted",
        "Vui lòng đợi 60 giây trước khi gửi lại mã.",
      );
    }

    const code = crypto.randomInt(0, 1000000).toString().padStart(6, "0");
    await reference.set({
      email,
      codeHash: codeHash(email, code),
      attempts: 0,
      consumed: false,
      expiresAt: new Date(Date.now() + 10 * 60 * 1000),
      lastSentAt: FieldValue.serverTimestamp(),
    });

    const port = Number(smtpPort.value());
    const transporter = nodemailer.createTransport({
      host: smtpHost.value(),
      port,
      secure: port === 465,
      auth: {user: smtpUser.value(), pass: smtpPass.value()},
    });
    try {
      await transporter.sendMail({
        from: smtpFrom.value(),
        to: email,
        subject: "Mã xác thực GeriatricCare",
        text: `Mã xác thực của bạn là ${code}. Mã có hiệu lực trong 10 phút.`,
        html: `<p>Mã xác thực GeriatricCare của bạn:</p>
          <p style="font-size:32px;font-weight:bold;letter-spacing:8px">${code}</p>
          <p>Mã có hiệu lực trong 10 phút. Không chia sẻ mã này với người khác.</p>`,
      });
    } catch (error) {
      await reference.delete();
      logger.error("Cannot send registration email", {email, error});
      throw new HttpsError("internal", "Không thể gửi email xác thực.");
    }
    return {expiresInSeconds: 600};
  },
);

exports.completeEmailRegistration = onCall(
  {
    region: "asia-southeast1",
    secrets: [otpPepper],
  },
  async (request) => {
    const data = request.data || {};
    const email = String(data.email || "").trim().toLowerCase();
    const phone = String(data.phoneNumber || "");
    const password = String(data.password || "");
    const fullName = String(data.fullName || "").trim();
    const role = String(data.role || "");
    const gender = String(data.gender || "");
    const code = String(data.code || "");
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ||
        !/^\+84\d{9}$/.test(phone) ||
        !/^\d{6}$/.test(password) ||
        !/^\d{6}$/.test(code) ||
        fullName.length < 2 ||
        !["elder", "child", "caregiver"].includes(role) ||
        !["male", "female", "other"].includes(gender)) {
      throw new HttpsError("invalid-argument", "Thông tin đăng ký không hợp lệ.");
    }

    const db = getFirestore();
    const verificationRef = db.collection("email_verifications").doc(
      verificationId(email),
    );
    const verificationResult = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(verificationRef);
      const verification = snapshot.data();
      if (!verification || verification.consumed ||
          verification.expiresAt.toMillis() < Date.now()) {
        return "expired";
      }
      if (verification.attempts >= 5) {
        return "locked";
      }
      const suppliedHash = codeHash(email, code);
      const expected = Buffer.from(verification.codeHash, "hex");
      const supplied = Buffer.from(suppliedHash, "hex");
      if (expected.length !== supplied.length ||
          !crypto.timingSafeEqual(expected, supplied)) {
        transaction.update(verificationRef, {
          attempts: FieldValue.increment(1),
        });
        return "invalid";
      }
      transaction.update(verificationRef, {
        consumed: true,
        consumedAt: FieldValue.serverTimestamp(),
      });
      return "valid";
    });
    if (verificationResult === "expired") {
      throw new HttpsError("deadline-exceeded", "Mã đã hết hạn.");
    }
    if (verificationResult === "locked") {
      throw new HttpsError("permission-denied", "Bạn đã nhập sai quá nhiều lần.");
    }
    if (verificationResult === "invalid") {
      throw new HttpsError("invalid-argument", "Mã xác thực không chính xác.");
    }

    const loginRef = db.collection("login_directory").doc(phone);
    try {
      await loginRef.create({
        email,
        phoneNumber: phone,
        reserved: true,
        createdAt: FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw new HttpsError("already-exists", "Số điện thoại đã được sử dụng.");
    }

    let user;
    try {
      user = await getAuth().createUser({
        email,
        password,
        emailVerified: true,
        displayName: fullName,
      });
      const profile = {
        email,
        phoneNumber: phone,
        fullName,
        role,
        gender,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      };
      const batch = db.batch();
      batch.set(db.collection("users").doc(user.uid), profile);
      batch.set(db.collection("user_directory").doc(phone), {
        uid: user.uid,
        ...profile,
      });
      batch.set(loginRef, {
        uid: user.uid,
        email,
        phoneNumber: phone,
        updatedAt: FieldValue.serverTimestamp(),
      });
      await batch.commit();
      await verificationRef.delete();
      return {customToken: await getAuth().createCustomToken(user.uid)};
    } catch (error) {
      if (user) await getAuth().deleteUser(user.uid).catch(() => {});
      await loginRef.delete().catch(() => {});
      logger.error("Cannot complete email registration", {email, error});
      if (error.code === "auth/email-already-exists") {
        throw new HttpsError("already-exists", "Email đã được sử dụng.");
      }
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "Không thể hoàn tất đăng ký.");
    }
  },
);

exports.sendSosToLinkedChildren = onDocumentCreated(
  {
    document: "sos_alerts/{alertId}",
    region: "asia-southeast1",
  },
  async (event) => {
    const alert = event.data?.data();
    if (!alert || alert.status !== "active" || !alert.elderUserId) return;

    const db = getFirestore();
    const relationships = await db
      .collection("care_relationships")
      .where("elderId", "==", alert.elderUserId)
      .get();

    const childIds = [...new Set(
      relationships.docs
        .map((doc) => doc.data())
        .filter((relationship) => relationship.status === "accepted")
        .map((relationship) => relationship.childId)
        .filter(Boolean),
    )];
    if (childIds.length === 0) {
      await event.data.ref.update({
        notificationStatus: "no_linked_child",
        notificationProcessedAt: FieldValue.serverTimestamp(),
      });
      return;
    }

    const tokenDocs = [];
    for (let index = 0; index < childIds.length; index += 30) {
      const snapshot = await db
        .collection("fcm_tokens")
        .where("userId", "in", childIds.slice(index, index + 30))
        .get();
      tokenDocs.push(...snapshot.docs);
    }

    const uniqueTokens = [...new Set(
      tokenDocs.map((doc) => doc.data().token).filter(Boolean),
    )];
    if (uniqueTokens.length === 0) {
      await event.data.ref.update({
        notificationStatus: "no_registered_device",
        notificationProcessedAt: FieldValue.serverTimestamp(),
      });
      return;
    }

    let successCount = 0;
    let failureCount = 0;
    const invalidTokens = [];
    for (let index = 0; index < uniqueTokens.length; index += 500) {
      const tokens = uniqueTokens.slice(index, index + 500);
      const response = await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: "CẢNH BÁO SOS KHẨN CẤP",
          body: "Người thân của bạn đang cần được hỗ trợ. Hãy liên hệ ngay!",
        },
        data: {
          type: "sos",
          alertId: event.params.alertId,
          elderId: alert.elderUserId,
        },
        android: {
          priority: "high",
          notification: {
            priority: "max",
            sound: "default",
            visibility: "public",
          },
        },
        apns: {
          payload: {aps: {sound: "default"}},
        },
        webpush: {
          notification: {requireInteraction: true},
        },
      });
      successCount += response.successCount;
      failureCount += response.failureCount;
      response.responses.forEach((result, responseIndex) => {
        const code = result.error?.code;
        if (
          code === "messaging/registration-token-not-registered" ||
          code === "messaging/invalid-registration-token"
        ) {
          invalidTokens.push(tokens[responseIndex]);
        }
      });
    }

    if (invalidTokens.length > 0) {
      const invalidSet = new Set(invalidTokens);
      const batch = db.batch();
      tokenDocs.forEach((doc) => {
        if (invalidSet.has(doc.data().token)) batch.delete(doc.ref);
      });
      await batch.commit();
    }

    await event.data.ref.update({
      notificationStatus: successCount > 0 ? "sent" : "failed",
      notificationSuccessCount: successCount,
      notificationFailureCount: failureCount,
      notificationProcessedAt: FieldValue.serverTimestamp(),
    });
    logger.info("SOS push notification processed", {
      alertId: event.params.alertId,
      successCount,
      failureCount,
    });
  },
);
