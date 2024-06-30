
import 'dart:math';

import 'package:dh_core/data/dh_store.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class AesEncrypt{
   static Future<String> encrypt(String content, {String? pwd}) async{
     if(pwd == null){
       String? p = await Store.getString("dh_aes_key");
       if(p == null){
         pwd = _randomStr(32);
         Store.setString("dh_aes_key", pwd);
       }else{
         pwd = p;
       }
     }
     if(pwd.length != 32){
       throw new Exception('pwd length must is 32');
     }
     final key = Key.fromUtf8(pwd);
     final iv = IV.fromUtf8(pwd.substring(0, 16));
     final encrypter = Encrypter(AES(key));
     final encrypted = encrypter.encrypt(content, iv: iv);
     return encrypted.base64;
   }

   static Future<String> decrypt(String content, {String? pwd}) async{
     if(pwd == null){
       String? p = await Store.getString("dh_aes_key");
       if(p == null){
         throw new Exception('pwd is lost');
       }else{
         pwd = p;
       }
     }
     if(pwd.length != 32){
       throw new Exception('pwd length must is 32');
     }
     final key = Key.fromUtf8(pwd);
     final iv = IV.fromUtf8(pwd.substring(0, 16));
     final encrypter = Encrypter(AES(key));
     final encrypted = encrypter.decrypt64(content, iv: iv);
     return encrypted;
   }

   static String _generate_MD5(String data) {
     var content = new Utf8Encoder().convert(data);
     var digest = md5.convert(content);
     // 这里其实就是 digest.toString()
     return hex.encode(digest.bytes);
   }

   static String _randomStr(int len){
     String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789';
     String left = '';
     for (var i = 0; i < len; i++) {
       left = left + alphabet[Random().nextInt(alphabet.length)];
     }
     return left;
   }
}