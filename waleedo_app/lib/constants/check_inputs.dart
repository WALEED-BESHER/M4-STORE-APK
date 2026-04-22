import 'dart:convert';
import 'package:crypto/crypto.dart';

class check_inputs {

  // ================= BASIC =================

  // إزالة المسافات من بداية ونهاية النص
  static String trim(String value) {
    return value.trim();
  }

  // تحويل النص إلى حروف صغيرة
  static String toLower(String value) {
    return value.toLowerCase();
  }

  // تحويل النص إلى حروف كبيرة
  static String toUpper(String value) {
    return value.toUpperCase();
  }

  // حذف جميع المسافات داخل النص
  static String removeSpaces(String value) {
    return value.replaceAll(RegExp(r'\s+'), '');
  }

  // ================= HTML =================

  // حذف جميع وسوم HTML مثل <script> أو <div>
  static String removeHtml(String value) {
    return value.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // تحويل رموز HTML إلى نص عادي لحماية XSS
  // مثل تحويل < إلى &lt;
  static String escapeHtml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }

  // ================= FILTER =================

  // السماح بالحروف فقط (عربي + إنجليزي)
  static String lettersOnly(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z\u0621-\u064A]'), '');
  }

  // السماح بالأرقام فقط
  static String numbersOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // السماح بالحروف والأرقام فقط
  static String lettersAndNumbers(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  // حذف الرموز الخاصة مثل ! @ # $ %
  static String removeSymbols(String value) {
    return value.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // ================= EMAIL =================

  // تنظيف الإيميل من المسافات والرموز الخطرة
  static String sanitizeEmail(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[<>]'), '')
        .replaceAll(RegExp(r'\s+'), '');
  }

  // التحقق من صحة الإيميل
  static bool validateEmail(String value) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);
  }

  // ================= PHONE =================

  // تنظيف رقم الهاتف والسماح بالأرقام و +
  static String sanitizePhone(String value) {
    return value.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  // ================= PASSWORD =================

  // تنظيف كلمة المرور من المسافات الزائدة
  static String sanitizePassword(String value) {
    return value.trim();
  }

  // ================= SECURITY =================

  // إزالة محاولات SQL Injection
  static String removeSQLInjection(String value) {
  return value.replaceAll(
    RegExp(r"(;|--|'|/\*|\*/|xp_)", caseSensitive: false),
    '',
  );
}

  // إزالة سكربتات JavaScript لمنع XSS
  static String removeXSS(String value) {
    return value.replaceAll(
      RegExp(r'<script.*?>.*?<\/script>'),
      '',
    );
  }

  // ================= HASH =================

  // تشفير النص باستخدام SHA1
  static String sha1Hash(String value) {
    return sha1.convert(utf8.encode(value)).toString();
  }

  // تشفير النص باستخدام SHA256 (أقوى)
  static String sha256Hash(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  // تشفير النص باستخدام MD5
  static String md5Hash(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }

  // ================= BASE64 =================

  // تحويل النص إلى Base64
  static String base64EncodeText(String value) {
    return base64Encode(utf8.encode(value));
  }

  // فك تشفير Base64
  static String base64DecodeText(String value) {
    return utf8.decode(base64Decode(value));
  }

  // ================= SLUG =================

  // تحويل النص إلى رابط URL friendly
  // مثال: Hello World -> hello-world
  static String slug(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
  }
}