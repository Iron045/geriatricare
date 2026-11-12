"use strict";

require("dotenv").config();
const crypto = require("node:crypto");
const fs = require("node:fs/promises");
const cors = require("cors");
const express = require("express");
const {cert, initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {FieldValue, getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const nodemailer = require("nodemailer");
const path = require("node:path");

const app = express();
const port = Number(process.env.PORT || 3000);
const entries = new Map();
const documentOpenTokens = new Map();
const lifetimeMs = 10 * 60 * 1000;
const resendDelayMs = 60 * 1000;
const medicalFilesRoot = path.resolve(
  process.env.MEDICAL_FILES_DIR || "D:\\Server\\medical_documents",
);
const maxMedicalFileBytes = 15 * 1024 * 1024;

const serviceAccountPath = path.resolve(
  __dirname,
  process.env.FIREBASE_SERVICE_ACCOUNT || "service-account.json",
);
let firebaseAuth;
let firebaseDb;
let firebaseMessaging;
try {
  const serviceAccount = require(serviceAccountPath);
  initializeApp({credential: cert(serviceAccount)});
  firebaseAuth = getAuth();
  firebaseDb = getFirestore();
  firebaseMessaging = getMessaging();
} catch (error) {
  console.error(
    "Không thể đọc Firebase Service Account. " +
      "Hãy đặt file service-account.json trong thư mục otp_server.",
  );
  console.error(error.message);
  process.exit(1);
}

app.use(cors());
app.use(express.json({limit: "22mb"}));

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT || 465),
  secure: Number(process.env.SMTP_PORT || 465) === 465,
  auth: {
    user: process.env.SMTP_USER,
    pass: String(process.env.SMTP_PASS || "").replace(/\s/g, ""),
  },
});

const normalizeEmail = (value) => String(value || "").trim().toLowerCase();
const validEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
const hashCode = (email, code) =>
  crypto.createHash("sha256").update(`${email}:${code}`).digest();

app.get("/health", (_request, response) => {
  response.json({
    ok: true,
    service: "geriatriccare-server",
    features: [
      "email-otp",
      "sos-push",
      "medical-document-upload",
      "medical-document-read",
    ],
    medicalFilesRoot,
  });
});

async function authenticatedUser(request) {
  const authorization = String(request.headers.authorization || "");
  if (!authorization.startsWith("Bearer ")) {
    const error = new Error("Thiếu thông tin xác thực.");
    error.statusCode = 401;
    throw error;
  }
  return firebaseAuth.verifyIdToken(authorization.substring(7));
}

async function canAccessElder(uid, elderId) {
  if (uid === elderId) return true;
  const relationship = await firebaseDb
    .collection("care_relationships")
    .doc(`${elderId}_${uid}`)
    .get();
  return relationship.exists && relationship.data()?.status === "accepted";
}

function safePathPart(value) {
  return String(value || "").replace(/[^a-zA-Z0-9._-]/g, "_");
}

app.post("/medical-documents", async (request, response) => {
  try {
    const user = await authenticatedUser(request);
    const elderId = String(request.body?.elderId || "").trim();
    const visitId = String(request.body?.visitId || "").trim();
    const fileName = String(request.body?.fileName || "").trim();
    const contentType = String(request.body?.contentType || "").trim();
    const encodedData = String(request.body?.data || "");
    if (!elderId || !visitId || !fileName || !encodedData) {
      return response.status(400).json({message: "Thông tin tệp chưa đầy đủ."});
    }
    if (!contentType.startsWith("image/") && contentType !== "application/pdf") {
      return response.status(415).json({message: "Chỉ chấp nhận tệp ảnh hoặc PDF."});
    }

    const visitReference = firebaseDb.collection("medical_visits").doc(visitId);
    const visit = await visitReference.get();
    if (!visit.exists || visit.data()?.elderUserId !== elderId) {
      return response.status(404).json({message: "Không tìm thấy hồ sơ khám."});
    }
    if (!(await canAccessElder(user.uid, elderId))) {
      return response.status(403).json({message: "Bạn không có quyền thêm tài liệu."});
    }

    const bytes = Buffer.from(encodedData, "base64");
    if (!bytes.length || bytes.length > maxMedicalFileBytes) {
      return response.status(413).json({message: "Tệp phải nhỏ hơn 15 MB."});
    }
    const storedName = `${crypto.randomUUID()}_${safePathPart(fileName)}`;
    const relativePath = path.join(
      safePathPart(elderId),
      safePathPart(visitId),
      storedName,
    );
    const absolutePath = path.join(medicalFilesRoot, relativePath);
    if (!absolutePath.startsWith(`${medicalFilesRoot}${path.sep}`)) {
      throw new Error("Đường dẫn lưu tệp không hợp lệ.");
    }
    await fs.mkdir(path.dirname(absolutePath), {recursive: true});
    await fs.writeFile(absolutePath, bytes, {flag: "wx"});

    const document = visitReference.collection("documents").doc();
    await document.set({
      elderUserId: elderId,
      visitId,
      fileName,
      storagePath: path.join("medical_documents", relativePath)
        .replaceAll("\\", "/"),
      contentType,
      size: bytes.length,
      uploadedById: user.uid,
      storageProvider: "local_node",
      createdAt: FieldValue.serverTimestamp(),
    });
    return response.status(201).json({ok: true, documentId: document.id});
  } catch (error) {
    console.error("Không thể lưu tài liệu khám:", error.message);
    return response.status(error.statusCode || 500).json({
      message: error.statusCode ? error.message : "Không thể lưu tệp trên máy chủ.",
    });
  }
});

app.get("/medical-documents/:visitId/:documentId", async (request, response) => {
  try {
    const user = await authenticatedUser(request);
    const visitId = safePathPart(request.params.visitId);
    const documentId = safePathPart(request.params.documentId);
    const visitReference = firebaseDb.collection("medical_visits").doc(visitId);
    const [visit, document] = await Promise.all([
      visitReference.get(),
      visitReference.collection("documents").doc(documentId).get(),
    ]);
    if (!visit.exists || !document.exists) {
      return response.status(404).json({message: "Không tìm thấy tài liệu."});
    }
    const elderId = String(visit.data()?.elderUserId || "");
    if (!(await canAccessElder(user.uid, elderId))) {
      return response.status(403).json({message: "Bạn không có quyền xem tài liệu."});
    }
    const data = document.data();
    if (data?.storageProvider !== "local_node") {
      return response.status(404).json({
        message: "Tài liệu này không được lưu trên máy chủ Node.js.",
      });
    }
    const prefix = "medical_documents/";
    const storagePath = String(data.storagePath || "").replaceAll("\\", "/");
    if (!storagePath.startsWith(prefix)) {
      throw new Error("Đường dẫn tài liệu không hợp lệ.");
    }
    const absolutePath = path.resolve(
      medicalFilesRoot,
      storagePath.substring(prefix.length),
    );
    if (!absolutePath.startsWith(`${medicalFilesRoot}${path.sep}`)) {
      throw new Error("Đường dẫn tài liệu không hợp lệ.");
    }
    const bytes = await fs.readFile(absolutePath);
    response.setHeader("Content-Type", data.contentType || "application/octet-stream");
    response.setHeader(
      "Content-Disposition",
      `inline; filename="${safePathPart(data.fileName)}"`,
    );
    return response.send(bytes);
  } catch (error) {
    const notFound = error.code === "ENOENT";
    console.error("Không thể đọc tài liệu khám:", error.message);
    return response.status(notFound ? 404 : (error.statusCode || 500)).json({
      message: notFound ? "Tệp không còn tồn tại trên máy chủ." :
        (error.statusCode ? error.message : "Không thể đọc tệp trên máy chủ."),
    });
  }
});

app.post("/medical-documents/:visitId/:documentId/open", async (request, response) => {
  try {
    const user = await authenticatedUser(request);
    const visitId = safePathPart(request.params.visitId);
    const documentId = safePathPart(request.params.documentId);
    const visitReference = firebaseDb.collection("medical_visits").doc(visitId);
    const [visit, document] = await Promise.all([
      visitReference.get(),
      visitReference.collection("documents").doc(documentId).get(),
    ]);
    if (!visit.exists || !document.exists) {
      return response.status(404).json({message: "Không tìm thấy tài liệu."});
    }
    const elderId = String(visit.data()?.elderUserId || "");
    if (!(await canAccessElder(user.uid, elderId))) {
      return response.status(403).json({message: "Bạn không có quyền xem tài liệu."});
    }
    const data = document.data();
    if (data?.storageProvider !== "local_node") {
      return response.status(404).json({message: "PDF không có trên máy chủ Node.js."});
    }
    const token = crypto.randomBytes(32).toString("hex");
    documentOpenTokens.set(token, {
      storagePath: data.storagePath,
      contentType: data.contentType,
      fileName: data.fileName,
      expiresAt: Date.now() + 2 * 60 * 1000,
    });
    return response.json({path: `/medical-document-open/${token}`});
  } catch (error) {
    return response.status(error.statusCode || 500).json({
      message: error.statusCode ? error.message : "Không thể tạo liên kết PDF.",
    });
  }
});

app.get("/medical-document-open/:token", async (request, response) => {
  const token = String(request.params.token || "");
  const entry = documentOpenTokens.get(token);
  if (!entry || entry.expiresAt < Date.now()) {
    documentOpenTokens.delete(token);
    return response.status(410).send("Liên kết đã hết hạn.");
  }
  try {
    const prefix = "medical_documents/";
    const storagePath = String(entry.storagePath || "").replaceAll("\\", "/");
    if (!storagePath.startsWith(prefix)) throw new Error("Đường dẫn không hợp lệ.");
    const absolutePath = path.resolve(
      medicalFilesRoot,
      storagePath.substring(prefix.length),
    );
    if (!absolutePath.startsWith(`${medicalFilesRoot}${path.sep}`)) {
      throw new Error("Đường dẫn không hợp lệ.");
    }
    const bytes = await fs.readFile(absolutePath);
    response.setHeader("Content-Type", entry.contentType || "application/pdf");
    response.setHeader(
      "Content-Disposition",
      `inline; filename="${safePathPart(entry.fileName)}"`,
    );
    return response.send(bytes);
  } catch (error) {
    return response.status(error.code === "ENOENT" ? 404 : 500)
      .send("Không thể đọc PDF.");
  }
});

async function processSosAlert(alertDocument) {
  const alertRef = alertDocument.ref;
  const claimed = await firebaseDb.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(alertRef);
    const alert = snapshot.data();
    if (!alert || alert.status !== "active" ||
        alert.notificationProcessedAt || alert.notificationProcessingAt) {
      return false;
    }
    transaction.update(alertRef, {
      notificationProcessingAt: FieldValue.serverTimestamp(),
    });
    return true;
  });
  if (!claimed) return;

  try {
    const alert = alertDocument.data();
    const elderId = alert.elderUserId;
    const [relationships, elderProfile] = await Promise.all([
      firebaseDb.collection("care_relationships")
        .where("elderId", "==", elderId)
        .get(),
      firebaseDb.collection("users").doc(elderId).get(),
    ]);
    const childIds = [...new Set(
      relationships.docs
        .map((doc) => doc.data())
        .filter((relationship) => relationship.status === "accepted")
        .map((relationship) => relationship.childId)
        .filter(Boolean),
    )];
    if (childIds.length === 0) {
      await alertRef.update({
        notificationStatus: "no_linked_child",
        notificationProcessedAt: FieldValue.serverTimestamp(),
        notificationProcessingAt: FieldValue.delete(),
      });
      return;
    }

    const tokenDocuments = [];
    for (let index = 0; index < childIds.length; index += 30) {
      const result = await firebaseDb.collection("fcm_tokens")
        .where("userId", "in", childIds.slice(index, index + 30))
        .get();
      tokenDocuments.push(...result.docs);
    }
    const tokens = [...new Set(
      tokenDocuments.map((doc) => doc.data().token).filter(Boolean),
    )];
    if (tokens.length === 0) {
      await alertRef.update({
        notificationStatus: "no_registered_device",
        notificationProcessedAt: FieldValue.serverTimestamp(),
        notificationProcessingAt: FieldValue.delete(),
      });
      return;
    }

    const elderName = elderProfile.data()?.fullName || "Người thân của bạn";
    let successCount = 0;
    let failureCount = 0;
    const invalidTokens = new Set();
    for (let index = 0; index < tokens.length; index += 500) {
      const tokenBatch = tokens.slice(index, index + 500);
      const result = await firebaseMessaging.sendEachForMulticast({
        tokens: tokenBatch,
        notification: {
          title: "CẢNH BÁO SOS KHẨN CẤP",
          body: `${elderName} đang cần được hỗ trợ. Hãy liên hệ ngay!`,
        },
        data: {
          type: "sos",
          alertId: alertDocument.id,
          elderId,
        },
        android: {
          priority: "high",
          notification: {
            priority: "max",
            sound: "default",
            visibility: "public",
            channelId: "sos_emergency",
          },
        },
        apns: {payload: {aps: {sound: "default"}}},
      });
      successCount += result.successCount;
      failureCount += result.failureCount;
      result.responses.forEach((response, responseIndex) => {
        const code = response.error?.code;
        if (code === "messaging/registration-token-not-registered" ||
            code === "messaging/invalid-registration-token") {
          invalidTokens.add(tokenBatch[responseIndex]);
        }
      });
    }

    if (invalidTokens.size > 0) {
      const batch = firebaseDb.batch();
      tokenDocuments.forEach((document) => {
        if (invalidTokens.has(document.data().token)) batch.delete(document.ref);
      });
      await batch.commit();
    }
    await alertRef.update({
      notificationStatus: successCount > 0 ? "sent" : "failed",
      notificationSuccessCount: successCount,
      notificationFailureCount: failureCount,
      notificationProcessedAt: FieldValue.serverTimestamp(),
      notificationProcessingAt: FieldValue.delete(),
    });
    console.log(`Đã xử lý SOS ${alertDocument.id}: ${successCount} thành công, ${failureCount} lỗi.`);
  } catch (error) {
    console.error(`Không thể gửi SOS ${alertDocument.id}:`, error.message);
    await alertRef.update({
      notificationStatus: "failed",
      notificationError: String(error.message).slice(0, 300),
      notificationProcessedAt: FieldValue.serverTimestamp(),
      notificationProcessingAt: FieldValue.delete(),
    }).catch(() => {});
  }
}

function startSosWatcher() {
  return firebaseDb.collection("sos_alerts")
    .where("status", "==", "active")
    .onSnapshot((snapshot) => {
      snapshot.docChanges()
        .filter((change) => change.type === "added" || change.type === "modified")
        .forEach((change) => void processSosAlert(change.doc));
    }, (error) => console.error("Bộ theo dõi SOS bị lỗi:", error.message));
}

async function processAppointmentNotification(appointmentDocument) {
  const reference = appointmentDocument.ref;
  const claimed = await firebaseDb.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(reference);
    const appointment = snapshot.data();
    if (!appointment?.assigneeId || appointment.notificationProcessedAt ||
        appointment.notificationProcessingAt) {
      return false;
    }
    transaction.update(reference, {
      notificationProcessingAt: FieldValue.serverTimestamp(),
    });
    return true;
  });
  if (!claimed) return;

  try {
    const appointment = appointmentDocument.data();
    const tokensSnapshot = await firebaseDb.collection("fcm_tokens")
      .where("userId", "==", appointment.assigneeId)
      .get();
    const tokens = [...new Set(
      tokensSnapshot.docs.map((doc) => doc.data().token).filter(Boolean),
    )];
    if (tokens.length === 0) {
      await reference.update({
        notificationStatus: "no_registered_device",
        notificationProcessedAt: FieldValue.serverTimestamp(),
        notificationProcessingAt: FieldValue.delete(),
      });
      return;
    }

    const scheduledAt = appointment.scheduledAt?.toDate?.();
    const timeText = scheduledAt
      ? scheduledAt.toLocaleString("vi-VN", {timeZone: "Asia/Ho_Chi_Minh"})
      : "thời gian đã lên lịch";
    const result = await firebaseMessaging.sendEachForMulticast({
      tokens,
      notification: {
        title: "Bạn được phân công đưa đi khám",
        body: `${appointment.title || "Lịch khám"} tại ${appointment.hospitalName || "cơ sở y tế"}, ${timeText}.`,
      },
      data: {
        type: "appointment_assignment",
        appointmentId: appointmentDocument.id,
        elderId: String(appointment.elderUserId || ""),
      },
      android: {
        priority: "high",
        notification: {
          channelId: "appointment_updates",
          sound: "default",
        },
      },
      apns: {payload: {aps: {sound: "default"}}},
    });
    await reference.update({
      notificationStatus: result.successCount > 0 ? "sent" : "failed",
      notificationSuccessCount: result.successCount,
      notificationFailureCount: result.failureCount,
      notificationProcessedAt: FieldValue.serverTimestamp(),
      notificationProcessingAt: FieldValue.delete(),
    });
    console.log(`Đã gửi thông báo lịch khám ${appointmentDocument.id}: ${result.successCount} thành công.`);
  } catch (error) {
    console.error(`Không thể gửi thông báo lịch khám ${appointmentDocument.id}:`, error.message);
    await reference.update({
      notificationStatus: "failed",
      notificationError: String(error.message).slice(0, 300),
      notificationProcessedAt: FieldValue.serverTimestamp(),
      notificationProcessingAt: FieldValue.delete(),
    }).catch(() => {});
  }
}

function startAppointmentWatcher() {
  return firebaseDb.collection("medical_appointments")
    .onSnapshot((snapshot) => {
      snapshot.docChanges()
        .filter((change) => change.type === "added" || change.type === "modified")
        .forEach((change) => void processAppointmentNotification(change.doc));
    }, (error) => console.error("Bộ theo dõi lịch khám bị lỗi:", error.message));
}

app.post("/otp/send", async (request, response) => {
  const email = normalizeEmail(request.body?.email);
  if (!validEmail(email)) {
    return response.status(400).json({message: "Email không hợp lệ."});
  }
  const previous = entries.get(email);
  if (previous && Date.now() - previous.sentAt < resendDelayMs) {
    return response.status(429).json({message: "Vui lòng đợi 60 giây trước khi gửi lại mã."});
  }

  try {
    await firebaseAuth.getUserByEmail(email);
    return response.status(409).json({message: "Email đã được sử dụng."});
  } catch (error) {
    if (error.code !== "auth/user-not-found") {
      console.error("Không thể kiểm tra email Firebase:", error.message);
      return response.status(500).json({
        message: "Không thể kiểm tra email. Vui lòng thử lại.",
      });
    }
  }

  const code = crypto.randomInt(0, 1000000).toString().padStart(6, "0");
  try {
    await transporter.sendMail({
      from: process.env.SMTP_FROM || process.env.SMTP_USER,
      to: email,
      subject: "Mã xác thực GeriatricCare",
      text: `Mã xác thực của bạn là ${code}. Mã có hiệu lực trong 10 phút.`,
      html: `<p>Mã xác thực GeriatricCare của bạn:</p><p style="font-size:32px;font-weight:bold;letter-spacing:8px">${code}</p><p>Mã có hiệu lực trong 10 phút và chỉ dùng được một lần.</p>`,
    });
    entries.set(email, {
      codeHash: hashCode(email, code),
      expiresAt: Date.now() + lifetimeMs,
      sentAt: Date.now(),
      attempts: 0,
    });
    return response.json({ok: true, expiresInSeconds: 600});
  } catch (error) {
    console.error("Không thể gửi OTP:", error.message);
    return response.status(500).json({message: "Không thể gửi email. Hãy kiểm tra Gmail App Password."});
  }
});

app.post("/otp/verify", (request, response) => {
  const email = normalizeEmail(request.body?.email);
  const code = String(request.body?.code || "").trim();
  if (!validEmail(email) || !/^\d{6}$/.test(code)) {
    return response.status(400).json({message: "Email hoặc mã OTP không hợp lệ."});
  }
  const entry = entries.get(email);
  if (!entry || entry.expiresAt < Date.now()) {
    entries.delete(email);
    return response.status(410).json({message: "Mã OTP đã hết hạn."});
  }
  if (entry.attempts >= 5) {
    entries.delete(email);
    return response.status(429).json({message: "Bạn đã nhập sai quá nhiều lần."});
  }
  const suppliedHash = hashCode(email, code);
  if (!crypto.timingSafeEqual(entry.codeHash, suppliedHash)) {
    entry.attempts += 1;
    return response.status(400).json({message: "Mã xác thực không chính xác."});
  }
  entries.delete(email);
  return response.json({ok: true, verified: true});
});

setInterval(() => {
  for (const [email, entry] of entries) {
    if (entry.expiresAt < Date.now()) entries.delete(email);
  }
}, 60000).unref();

app.listen(port, "0.0.0.0", () => {
  console.log(`GeriatricCare OTP server đang chạy tại http://0.0.0.0:${port}`);
  startSosWatcher();
  startAppointmentWatcher();
  console.log("Đã bật theo dõi SOS và gửi thông báo FCM.");
  console.log("Đã bật thông báo phân công lịch khám.");
});
