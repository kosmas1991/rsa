import 'package:flutter/material.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/pointycastle.dart' as crypto;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RsaKeyHelper help = RsaKeyHelper();
  late Future<crypto.AsymmetricKeyPair> futureKeyPair;
  late crypto.AsymmetricKeyPair keyPair;

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  @override
  void initState() {
    futureKeyPair = getKeyPair();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: futureKeyPair,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              keyPair = snapshot.data!;
              String encryptedString =
                  encrypt('kosmas', keyPair.publicKey as crypto.RSAPublicKey);
              String decryptedString = decrypt(
                  encryptedString, keyPair.privateKey as crypto.RSAPrivateKey);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'private key PEM: \n\n${help.encodePrivateKeyToPemPKCS1(keyPair.privateKey as crypto.RSAPrivateKey)}'),
                    Text(
                        '\n\npublic key PEM: \n\n${help.encodePublicKeyToPemPKCS1(keyPair.publicKey as crypto.RSAPublicKey)}'),
                    Text('\n\nencrypted text: \n\n${encryptedString}'),
                    Text('\n\ndecrypted text: \n\n${decryptedString}'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
