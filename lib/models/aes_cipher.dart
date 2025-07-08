import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptedInfo {
  final String iv;
  final String ciphertext;
  const EncryptedInfo(this.iv, this.ciphertext);
}

class AESCipher {
  late final Uint8List _key;
  
  AESCipher(String key) {
    _key = Uint8List.fromList(utf8.encode(keypadding(key)));
  }
  
  /// Pad with null bytes or trim the key to exactly 32 bytes
  String keypadding(String key) {
    List<int> keyBytes = utf8.encode(key);
    
    if (keyBytes.length == 32) {
      return key;
    } else if (keyBytes.length < 32) {
      keyBytes.addAll(List.filled(32 - keyBytes.length, 0));
    } else {
      keyBytes = keyBytes.sublist(0, 32);
    }
    
    return String.fromCharCodes(keyBytes);
  }
  
  /// Encrypts the given text using AES-CBC and returns base64 ciphertext and IV
  EncryptedInfo encryptText({required String text}) {
    late final Uint8List giv;
    final random = SecureRandom('Fortuna');
    final seed = Uint8List.fromList(
      List.generate(32, (index) => Random.secure().nextInt(256))
    );
    random.seed(KeyParameter(seed));
    
    giv = random.nextBytes(16);
    // Convert text to bytes
    final plainBytes = Uint8List.fromList(utf8.encode(text));
    
    // Apply PKCS7 padding
    final paddedBytes = _addPKCS7Padding(plainBytes, 16);
    
    // Create cipher
    final cipher = CBCBlockCipher(AESEngine());
    final params = ParametersWithIV(KeyParameter(_key), giv);
    cipher.init(true, params);
    
    // Encrypt
    final cipherBytes = Uint8List(paddedBytes.length);
    var offset = 0;
    while (offset < paddedBytes.length) {
      offset += cipher.processBlock(paddedBytes, offset, cipherBytes, offset);
    }

    return EncryptedInfo(base64.encode(giv), base64.encode(cipherBytes));
  }
  
  /// Decrypts the given ciphertext with the given IV
  String decrypt(EncryptedInfo cipherinfo) {
    try {
      // Decode base64 inputs
      final cipherBytes = base64.decode(cipherinfo.ciphertext);
      final ivBytes = base64.decode(cipherinfo.iv);
      
      // Create cipher
      final cipher = CBCBlockCipher(AESEngine());
      final params = ParametersWithIV(KeyParameter(_key), ivBytes);
      cipher.init(false, params);
      
      // Decrypt
      final decryptedBytes = Uint8List(cipherBytes.length);
      var offset = 0;
      while (offset < cipherBytes.length) {
        offset += cipher.processBlock(cipherBytes, offset, decryptedBytes, offset);
      }
      
      // Remove PKCS7 padding
      final unpaddedBytes = _removePKCS7Padding(decryptedBytes);
      
      // Convert to string
      return utf8.decode(unpaddedBytes);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
  
  /// Add PKCS7 padding
  Uint8List _addPKCS7Padding(Uint8List data, int blockSize) {
    final paddingLength = blockSize - (data.length % blockSize);
    final paddedData = Uint8List(data.length + paddingLength);
    paddedData.setRange(0, data.length, data);
    
    for (int i = data.length; i < paddedData.length; i++) {
      paddedData[i] = paddingLength;
    }
    
    return paddedData;
  }
  
  /// Remove PKCS7 padding
  Uint8List _removePKCS7Padding(Uint8List data) {
    final paddingLength = data.last;
    
    if (paddingLength < 1 || paddingLength > 16) {
      throw Exception('Invalid padding');
    }
    
    // Verify padding
    for (int i = data.length - paddingLength; i < data.length; i++) {
      if (data[i] != paddingLength) {
        throw Exception('Invalid padding');
      }
    }
    
    return data.sublist(0, data.length - paddingLength);
  }
}

// Example usage:
/*
void main() {
  final cipher = AESCipher('mySecretKey123');
  
  // Encrypt
  final result = cipher.encryptText(text: 'Hello, World!');
  
  // Decrypt
  final decrypted = cipher.decrypt(result);
  print('Decrypted: $decrypted');
}
*/