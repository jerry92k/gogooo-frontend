import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:asn1lib/asn1lib.dart";
import 'package:hex/hex.dart';
import "package:pointycastle/export.dart";

/**[Jerry]
 * 1. class 정의 : RSA 암호화 수행 모듈
 * 2. 수행내용
 *  2.1 키 생성(Asymmetric key-pair 생성)
 *  2.2 public key를 이용한 plain-text 암호화
 *  2.3 private key를 이용한 encrypted-text 복호화
 *  2.4 Key를 PEM 형태로 Encode
 *  2.5 PEM 형태를 Key로 Decode
 */

class RsaKeyHelper {
  // Keypair (public key - private key) 생성
  AsymmetricKeyPair generateKeyPair() {
    var keyParams =
        new RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    var secureRandom = new FortunaRandom();
    var random = new Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));

    var rngParams = new ParametersWithRandom(keyParams, secureRandom);
    var k = new RSAKeyGenerator();
    k.init(rngParams);

    return k.generateKeyPair();
  }

  // Public key를 이용한 plaintext 암호화
  String encrypt(String plaintext, RSAPublicKey publicKey) {
    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    var cipherText =
        cipher.process(new Uint8List.fromList(plaintext.codeUnits));

    return HEX.encode(cipherText);
  }

  //private Key를 이용한 encrypted-text 복호
  String decrypt(String ciphertext, RSAPrivateKey privateKey) {
    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
    cipher.init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    var decryptedText = cipher.process(HEX.decode(ciphertext));

    return new String.fromCharCodes(decryptedText);
  }

  // PEM 형태를 decoding하여 public key형태로 변환
  RSAPublicKey parsePublicKeyFromPem(pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(publicKeyDER);

    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements[0] as ASN1Integer;
    var exponent = pkSeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
        RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);

    return rsaPublicKey;
  }

  //Get PrivateKey from PEM

  // PEM 형태를 decoding하여 private key형태로 변환
  RSAPrivateKey parsePrivateKeyFromPem(pemString) {
    List<int> privateKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(privateKeyDER);

    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;
    var modulus = pkSeq.elements[1] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  // public key를 저장, 이동을 위한 PEM 형태로 인코딩
  encodePublicKeyToPem(RSAPublicKey publicKey) {
    var topLevel = new ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));
    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  // private key를 저장, 이동을 위한 PEM 형태로 인코딩
  encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var topLevel = new ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);

    var publicExponent = ASN1Integer(privateKey.exponent);
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }

  List<int> decodePEM(String pem) {
    var header = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
    ];
    var footer = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
    ];

    for (var h in header) {
      if (pem.startsWith(h)) {
        pem = pem.substring(h.length);
        break;
      }
    }
    for (var f in footer) {
      if (pem.endsWith(f)) {
        pem = pem.substring(0, pem.length - f.length);
        break;
      }
    }
    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    return base64.decode(pem);
  }
}
