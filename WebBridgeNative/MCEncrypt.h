//
//  MCEncrypt.h
//  WebBridgeNativeExample
//
//  Created by marco chen on 2016/12/5.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCEncrypt : NSObject
/*
 * DES加密数据 RSA加密DES密钥 公钥证书路径（默认mainBundle下 public_key.der）
 * 返回加密后数据base64编码 {key:xxx，data:XXX}
 */
+(NSDictionary*)encryptWithDESAndRSA:(NSData*) data withKey:(NSString*)key keyPath:(NSString*)keyPath;

/*
 * RSA加密 输入NSString类型数据 公钥证书路径（默认mainBundle下 public_key.der）
 * 返回加密后数据base64编码
 */
+(NSString*)RSAEncryptData:(NSString*)text keyPath:(NSString*)keyPath;

/*
 * RSA加密 输入NSString类型数据 公钥证书路径（默认mainBundle下 public_key.der）
 * 返回加密后数据base64编码
 */
+(NSData*)RSAEncryptToData:(NSString*)text keyPath:(NSString*)keyPath;

/*
 * DES加密 输入NSString类型数据和NSString加密密钥 返回加密后数据base64编码
 */
+(NSString*)DESEncryptWithBase64:(NSString*)str key:(NSString*)key;

/*
 * DES解密 输入密文base64和NSString解密密钥 返回解密后数据明文
 */
+(NSString*)DESDecryptBase64:(NSString*)base64 key:(NSString*)key;

/*
 * DES加密 输入NSData类型数据和NSString加密密钥 返回加密后数据
 */
+(NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

/*
 * DES加密 输入NSData类型密文和NSString解密密钥 返回解密后数据
 */
+(NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;
@end


/*
 * RSA加密 公钥文件默认为public_key.der
 */
@interface WDRSACrypt : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}

/*
 *指定证书路径
 */
- (id)initWithKeyPath:(NSString*) publicKeyPath;

- (NSData *) encryptWithData:(NSData *)content;

- (NSData *) encryptWithString:(NSString *)content;
@end
